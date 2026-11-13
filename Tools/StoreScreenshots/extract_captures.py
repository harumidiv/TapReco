"""Organize unmodified XCTest screenshot attachments by device and language."""
import json
import shutil
import sys
from pathlib import Path

source, destination = map(Path, sys.argv[1:3])
manifest = json.loads((source / 'manifest.json').read_text())
records = []
for test in manifest:
    for attachment in test.get('attachments', []):
        name = attachment['suggestedHumanReadableName']
        if not name.startswith('store-'):
            continue
        stem = name.split('_0_')[0].removeprefix('store-')
        language, scene = stem.rsplit('-', 1)
        device = 'iphone-duo' if 'Duo' in attachment['deviceName'] else 'iphone'
        output = destination / 'raw' / device / language / f'{scene}.png'
        output.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source / attachment['exportedFileName'], output)
        records.append({'device': device, 'language': language, 'scene': scene,
                        'path': str(output.relative_to(destination)),
                        'simulator': attachment['deviceName']})
(destination / 'captures.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
print(f'Exported {len(records)} unmodified screenshots')
