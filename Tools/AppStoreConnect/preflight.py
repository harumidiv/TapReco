import argparse
import json
from pathlib import Path
from apple_api import AppleAPI,ROOT,save
p=argparse.ArgumentParser();p.add_argument('--key',type=Path,required=True);p.add_argument('--issuer',required=True);a=p.parse_args();api=AppleAPI(a.key,a.issuer)
m=json.loads((ROOT/'appstore/metadata-1.4.1.json').read_text());aid=m['appId']
lib=api.request(f'/v1/apps/{aid}/assetLibrary')['data']
placements={}
locales=api.all(f"/v1/appStoreVersions/{m['versionId']}/appStoreVersionLocalizations")
for l in locales:placements[l['attributes']['locale']]=api.all(f"/v1/appStoreVersionLocalizations/{l['id']}/placements?sort=placementGroupPosition")
save(ROOT/'appstore/placements-before.json',placements)
save(ROOT/'appstore/library-info.json',{'libraryId':lib['id']})
print('Library:',lib['id'])
for l,rs in placements.items():print(l,'Existing placements:',[(r['attributes']['placementGroup'],r['attributes']['placementType']) for r in rs])
