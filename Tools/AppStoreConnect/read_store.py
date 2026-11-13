import json
import argparse
from pathlib import Path
from apple_api import AppleAPI, ROOT, save
parser=argparse.ArgumentParser()
parser.add_argument('--key',type=Path,required=True)
parser.add_argument('--issuer',required=True)
args=parser.parse_args()
api=AppleAPI(args.key,args.issuer)
apps=api.all('/v1/apps?filter[bundleId]=harumidiv.TapReco')
assert len(apps)==1
app=apps[0];aid=app['id']
versions=api.all(f'/v1/apps/{aid}/appStoreVersions?filter[platform]=IOS')
infos=api.all(f'/v1/apps/{aid}/appInfos')
result={'app':app,'versions':versions,'infos':infos,'versionLocalizations':{},'infoLocalizations':{}}
for v in versions:
 if v['attributes']['versionString'] in ['1.4.1','1.4.0']:
  result['versionLocalizations'][v['id']]=api.all(f"/v1/appStoreVersions/{v['id']}/appStoreVersionLocalizations")
for i in infos:
 result['infoLocalizations'][i['id']]=api.all(f"/v1/appInfos/{i['id']}/appInfoLocalizations")
save(ROOT/'appstore/remote-before.json',result)
reference=api.request('/v1/appAssetLibraryRefData')['data'][0]['attributes']
save(ROOT/'appstore/asset-reference.json',reference)
print('App:',aid,app['attributes']['name'])
print('Versions:',[(v['attributes']['versionString'],v['attributes']['appStoreState'],v['id']) for v in versions])
for rows in result['versionLocalizations'].values():
 for r in rows:
  if r['attributes']['locale']=='ja':print('Japanese version:',json.dumps(r['attributes'],ensure_ascii=False))
for rows in result['infoLocalizations'].values():
 for r in rows:
  if r['attributes']['locale']=='ja':print('Japanese app info:',json.dumps(r['attributes'],ensure_ascii=False))
