#!/usr/bin/env python3
"""Register the prepared 1.4.1 metadata/assets; never submits a review or build."""
import argparse
import hashlib
import json
import struct
import threading
import time
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from apple_api import AppleAPI, ROOT, payload, relation, save

GOOD_IMAGE={'COMPLETE','PREPARE_FOR_SUBMISSION','APPROVED','ACCEPTED'}
GOOD_PLACEMENT={'ACTIVE','PARENT_PREPARE_FOR_SUBMISSION'}

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--key',type=Path,required=True);p.add_argument('--issuer',required=True)
    p.add_argument('--apply',action='store_true');p.add_argument('--verify-only',action='store_true')
    args=p.parse_args();api=AppleAPI(args.key,args.issuer)
    metadata=json.loads((ROOT/'appstore/metadata-1.4.1.json').read_text())
    reference=json.loads((ROOT/'appstore/asset-reference.json').read_text())
    before=json.loads((ROOT/'appstore/remote-before.json').read_text())
    aid,vid,iid=metadata['appId'],metadata['versionId'],metadata['appInfoId']
    assert metadata['version']=='1.4.1' and metadata['bundleId']=='harumidiv.TapReco'
    version=api.request(f'/v1/appStoreVersions/{vid}')['data']
    assert version['attributes']['versionString']=='1.4.1'
    assert version['attributes']['appStoreState']=='PREPARE_FOR_SUBMISSION'
    info=api.request(f'/v1/appInfos/{iid}')['data']
    assert info['attributes']['appStoreState']=='PREPARE_FOR_SUBMISSION'
    mappings=next(x for x in reference['placementTypes'] if x['placementTypeId']=='APP_SCREENSHOT')['specMappings']
    manifest=json.loads((ROOT/'output/store-screenshots/files.json').read_text())
    images={}
    for entry in manifest:
        file=entry['path'];raw=(ROOT/'output/store-screenshots'/file).read_bytes()
        width,height=struct.unpack('>II',raw[16:24]);assert raw[25]==2
        matches=[(s,m) for s in reference['imageSpecs'] for m in mappings
                 if s['specId'] in m['specs'] and s['dimensions']['minWidth']==s['dimensions']['maxWidth']==width
                 and s['dimensions']['minHeight']==s['dimensions']['maxHeight']==height]
        assert len(matches)==1,(file,width,height,matches)
        spec,mapping=matches[0]
        images[file]={'entry':entry,'sha256':hashlib.sha256(raw).hexdigest(),'spec':spec['specId'],'group':mapping['placementGroupId']}
    assert len(images)==70
    for locale,f in metadata['localizations'].items():
        for name,limit in [('name',30),('subtitle',30),('description',4000)]:assert 0<len(f[name])<=limit,(locale,name)
        # Existing Japanese keywords are preserved byte-for-byte, including their legacy length.
        if locale!='ja':assert 0<len(f['keywords'].encode())<=100,locale
    print(f"Validated {len(metadata['localizations'])} store locales, 7 languages, 70 RGB images",flush=True)
    if not args.apply and not args.verify_only:return
    checkpoint=ROOT/'appstore/upload-state-1.4.1.json'
    state=json.loads(checkpoint.read_text()) if checkpoint.exists() else {'versionId':vid,'metadata':{},'images':{},'placements':{},'removedPlacements':[]}
    assert state['versionId']==vid
    lock=threading.Lock()
    def checkpoint_save():save(checkpoint,state)
    if args.verify_only:
        verify(api,metadata,before,images,state);return
    vmap={r['attributes']['locale']:r for r in api.all(f'/v1/appStoreVersions/{vid}/appStoreVersionLocalizations')}
    imap={r['attributes']['locale']:r for r in api.all(f'/v1/appInfos/{iid}/appInfoLocalizations')}
    for locale,f in metadata['localizations'].items():
        ia={k:f[k] for k in ['name','subtitle']};ia['privacyPolicyUrl']=metadata['sharedUrls']['privacyPolicyUrl']
        va={k:f[k] for k in ['description','keywords']};va.update({k:metadata['sharedUrls'][k] for k in ['supportUrl','marketingUrl']})
        if 'whatsNew' in f:va['whatsNew']=f['whatsNew']
        for kind,attrs,rows,parent,pid,rel in [('appInfoLocalizations',ia,imap,'appInfos',iid,'appInfo'),('appStoreVersionLocalizations',va,vmap,'appStoreVersions',vid,'appStoreVersion')]:
            if locale not in rows:
                rows.update({r['attributes']['locale']:r for r in api.all(f'/v1/{parent}/{pid}/{kind}')})
            if locale not in rows:
                row=api.request(f'/v1/{kind}','POST',payload(kind,dict(attrs,locale=locale),{rel:relation(parent,pid)}))['data']
            else:
                row=rows[locale]
                if any(row['attributes'].get(k)!=v for k,v in attrs.items()):
                    row=api.request(f"/v1/{kind}/{row['id']}",'PATCH',payload(kind,attrs,identifier=row['id']))['data']
            rows[locale]=row;state['metadata'].setdefault(locale,{})[kind]=row['id'];checkpoint_save()
        print('Metadata registered:',locale,flush=True)
    library=api.request(f'/v1/apps/{aid}/assetLibrary')['data']['id']
    existing=api.all(f'/v1/appAssetLibraries/{library}/images?limit=200')
    by_reference={r['attributes'].get('referenceName'):r for r in existing}
    # Mint the token before the independent asset workers begin.
    api.token()
    def upload(item_pair):
        file,item=item_pair;entry=item['entry']
        ref=f"TapReco 1.4.1 {entry['language']} {entry['device']} {Path(file).stem} {item['sha256'][:12]}"
        row=by_reference.get(ref)
        if row is None:
            row=api.request('/v1/appAssetLibraryImages','POST',payload('appAssetLibraryImages',{
                'fileName':f"{entry['language']}-{entry['device']}-{Path(file).name}",
                'fileSize':entry['bytes'],'category':'APP_SCREENSHOTS_AND_PREVIEWS','referenceName':ref},
                {'assetLibrary':relation('appAssetLibraries',library)}))['data']
        image_id=row['id']
        with lock:
            state['images'][file]={'id':image_id,'sha256':item['sha256'],'group':item['group']};checkpoint_save()
        if row['attributes']['state']=='AWAITING_UPLOAD':
            raw=(ROOT/'output/store-screenshots'/file).read_bytes()
            for op in row['attributes']['uploadOperations']:
                headers={h['name']:h['value'] for h in op['requestHeaders']}
                part=raw[op['offset']:op['offset']+op['length']]
                request=urllib.request.Request(op['url'],data=part,method=op['method'],headers=headers)
                for attempt in range(3):
                    try:
                        with urllib.request.urlopen(request,timeout=60) as response:response.read()
                        break
                    except urllib.error.URLError:
                        if attempt==2:raise RuntimeError(f'Asset transfer failed: {file}') from None
                        time.sleep(2)
            row=api.request(f'/v1/appAssetLibraryImages/{image_id}','PATCH',payload('appAssetLibraryImages',{'uploaded':True},identifier=image_id))['data']
        deadline=time.time()+180
        while row['attributes']['state'] in {'UPLOAD_COMPLETE','AWAITING_UPLOAD'} and time.time()<deadline:
            time.sleep(2);row=api.request(f'/v1/appAssetLibraryImages/{image_id}')['data']
        if row['attributes']['state'] not in GOOD_IMAGE:
            raise RuntimeError(f"Image processing failed: {file} {row['attributes']['state']} {row['attributes'].get('stateDetails')}")
        assert row['attributes']['specId']==item['spec'],file
        with lock:
            state['images'][file].update({'state':row['attributes']['state'],'specId':item['spec']});checkpoint_save()
        return file
    with ThreadPoolExecutor(max_workers=4) as executor:
        futures=[executor.submit(upload,item) for item in images.items()]
        for count,future in enumerate(as_completed(futures),1):print(f'Image processed {count}/70: {future.result()}',flush=True)
    for locale,f in metadata['localizations'].items():
        lid=vmap[locale]['id']
        existing=api.all(f'/v1/appStoreVersionLocalizations/{lid}/placements?sort=placementGroupPosition')
        if 'placementsBefore' not in state:state['placementsBefore']={}
        state['placementsBefore'].setdefault(locale,existing);checkpoint_save()
        groups={}
        for file,item in images.items():
            if item['entry']['language']!=f['screenshotLanguage']:continue
            image_id=state['images'][file]['id']
            row=next((r for r in existing if r.get('relationships',{}).get('image',{}).get('data',{}).get('id')==image_id and r['attributes']['placementGroup']==item['group']),None)
            if row is None:
                row=api.request('/v1/appAssetLibraryPlacements','POST',payload('appAssetLibraryPlacements',
                    {'placementType':'APP_SCREENSHOT','placementGroup':item['group']},
                    {'image':relation('appAssetLibraryImages',image_id),'appStoreVersionLocalization':relation('appStoreVersionLocalizations',lid)}))['data']
            state['placements'][locale+'/'+file]={'id':row['id'],'group':item['group'],'state':row['attributes']['state']}
            groups.setdefault(item['group'],[]).append(row['id']);checkpoint_save()
        # Replace older screenshot placements in these two display groups only.
        # Source images stay in the library, and the previous placement data is backed up.
        for group,ids in groups.items():
            old=[r for r in existing if r['attributes']['placementType']=='APP_SCREENSHOT' and r['attributes']['placementGroup']==group and r['id'] not in ids]
            for r in old:
                api.request(f"/v1/appAssetLibraryPlacements/{r['id']}",'DELETE')
                state['removedPlacements'].append({'locale':locale,'placement':r});checkpoint_save()
            api.request('/v1/appAssetLibraryPlacementOrderingRequests','POST',payload('appAssetLibraryPlacementOrderingRequests',{'placementGroup':group},
                {'appStoreVersionLocalization':relation('appStoreVersionLocalizations',lid),
                 'orderedPlacements':{'data':[{'type':'appAssetLibraryPlacements','id':pid} for pid in ids]}}))
        print(f'Screenshots registered and ordered: {locale} (5 iPhone + 5 Duo)',flush=True)
    verify(api,metadata,before,images,state)


def verify(api,metadata,before,images,state):
    aid,vid,iid=metadata['appId'],metadata['versionId'],metadata['appInfoId']
    vr={r['attributes']['locale']:r for r in api.all(f'/v1/appStoreVersions/{vid}/appStoreVersionLocalizations')}
    ir={r['attributes']['locale']:r for r in api.all(f'/v1/appInfos/{iid}/appInfoLocalizations')}
    report={'appId':aid,'version':'1.4.1','versionId':vid,'submittedForReview':False,'localizations':{},'uniqueImages':len(images),
            'previousTargetPlacementsReplaced':len(state['removedPlacements']),'sharedUrls':metadata['sharedUrls']}
    total=0
    for locale,f in metadata['localizations'].items():
        for field in ['name','subtitle']:assert ir[locale]['attributes'][field]==f[field],(locale,field)
        for field in ['description','keywords']:assert vr[locale]['attributes'][field]==f[field],(locale,field)
        if 'whatsNew' in f:assert vr[locale]['attributes']['whatsNew']==f['whatsNew'],(locale,'whatsNew')
        for field in ['supportUrl','marketingUrl']:assert vr[locale]['attributes'][field]==metadata['sharedUrls'][field],(locale,field)
        assert ir[locale]['attributes']['privacyPolicyUrl']==metadata['sharedUrls']['privacyPolicyUrl']
        placements=api.all(f"/v1/appStoreVersionLocalizations/{vr[locale]['id']}/placements?sort=placementGroupPosition")
        group_report={}
        for group in ['IPHONE_DYNAMIC_ISLAND_LARGE_PROFILE','IPHONE_DUO_PROFILE']:
            rows=[r for r in placements if r['attributes']['placementType']=='APP_SCREENSHOT' and r['attributes']['placementGroup']==group]
            expected=[state['placements'][locale+'/'+file]['id'] for file,item in images.items() if item['entry']['language']==f['screenshotLanguage'] and item['group']==group]
            assert len(rows)==5,(locale,group,len(rows))
            assert [r['id'] for r in rows]==expected,(locale,group,'ordering')
            assert all(r['attributes']['state'] in GOOD_PLACEMENT and not r['attributes'].get('stateDetails') for r in rows),(locale,group,'state')
            group_report[group]=[r['id'] for r in rows];total+=len(rows)
        report['localizations'][locale]={'name':f['name'],'subtitle':f['subtitle'],'screenshots':10,'groups':group_report}
    original_v=next(r for r in before['versionLocalizations'][vid] if r['attributes']['locale']=='ja')
    original_i=next(r for r in before['infoLocalizations'][iid] if r['attributes']['locale']=='ja')
    expected_japanese=dict(original_v['attributes'])
    if 'whatsNew' in metadata['localizations']['ja']:
        expected_japanese['whatsNew']=metadata['localizations']['ja']['whatsNew']
    assert vr['ja']['attributes']==expected_japanese,'Japanese base text or expected release notes changed'
    assert ir['ja']['attributes']==original_i['attributes'],'Japanese app info changed'
    # Live app-info metadata and the current 1.4.0 version remain untouched.
    for old in before['infos']:
        if old['attributes']['appStoreState']=='READY_FOR_SALE':
            current=api.all(f"/v1/appInfos/{old['id']}/appInfoLocalizations")
            assert {r['id']:r['attributes'] for r in current}=={r['id']:r['attributes'] for r in before['infoLocalizations'][old['id']]}
    report['japaneseTextPreserved']=True;report['liveAppInfoPreserved']=True;report['screenshotPlacements']=total
    version=api.request(f'/v1/appStoreVersions/{vid}')['data']
    assert version['attributes']['appStoreState']=='PREPARE_FOR_SUBMISSION'
    report['versionState']=version['attributes']['appStoreState']
    save(ROOT/'appstore/upload-report-1.4.1.json',report)
    print(f"Verified {len(report['localizations'])} locales, {total} placements / 70 unique images; 1.4.1 remains PREPARE_FOR_SUBMISSION",flush=True)

if __name__=='__main__':main()
