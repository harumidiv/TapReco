#!/usr/bin/env python3
"""Update only the What's New field for the existing 1.4.1 localizations."""
import argparse
import json
from pathlib import Path
from apple_api import AppleAPI,ROOT,payload,save

NOTES={
    'ja':'ローカライズを行い、さまざまな言語に対応しました。',
    'en-US':"We've localized the app to support multiple languages.",
    'ko':'앱을 현지화하여 다양한 언어를 지원하도록 했습니다.',
    'zh-Hant':'我們已將 App 在地化，支援多種語言。',
    'es-ES':'Hemos localizado la app para que sea compatible con varios idiomas.',
    'es-MX':'Hemos localizado la app para que sea compatible con varios idiomas.',
    'pt-BR':'Localizamos o app para oferecer suporte a vários idiomas.',
    'id':'Aplikasi kini telah dilokalkan untuk mendukung berbagai bahasa.'
}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--key',type=Path,required=True)
    parser.add_argument('--issuer',required=True)
    args=parser.parse_args()
    api=AppleAPI(args.key,args.issuer)
    path=ROOT/'appstore/metadata-1.4.1.json'
    metadata=json.loads(path.read_text());vid=metadata['versionId']
    version=api.request(f'/v1/appStoreVersions/{vid}')['data']
    assert version['attributes']['versionString']=='1.4.1'
    assert version['attributes']['appStoreState']=='PREPARE_FOR_SUBMISSION'
    before=api.all(f'/v1/appStoreVersions/{vid}/appStoreVersionLocalizations')
    by_locale={r['attributes']['locale']:r for r in before}
    assert set(NOTES)==set(metadata['localizations'])
    assert set(NOTES)<=set(by_locale)
    backup=ROOT/'appstore/release-notes-before-1.4.1.json'
    if not backup.exists():save(backup,before)
    for locale,note in NOTES.items():
        row=by_locale[locale]
        if row['attributes'].get('whatsNew')!=note:
            api.request(f"/v1/appStoreVersionLocalizations/{row['id']}",'PATCH',
                        payload('appStoreVersionLocalizations',{'whatsNew':note},identifier=row['id']))
        print('Saved:',locale,flush=True)
    after=api.all(f'/v1/appStoreVersions/{vid}/appStoreVersionLocalizations')
    final={r['attributes']['locale']:r for r in after}
    for locale,note in NOTES.items():
        expected=dict(by_locale[locale]['attributes'],whatsNew=note)
        assert final[locale]['attributes']==expected,(locale,'unexpected metadata change')
        metadata['localizations'][locale]['whatsNew']=note
    save(path,metadata)
    state=api.request(f'/v1/appStoreVersions/{vid}')['data']['attributes']['appStoreState']
    assert state=='PREPARE_FOR_SUBMISSION'
    save(ROOT/'appstore/release-notes-report-1.4.1.json',{
        'version':'1.4.1','versionId':vid,'versionState':state,'notes':NOTES,
        'otherVersionMetadataPreserved':True,'submittedForReview':False})
    print('Verified: release notes saved for all 8 locales / 7 languages.',flush=True)

if __name__=='__main__':main()
