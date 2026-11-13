"""Validate PNG counts/dimensions/text widths and create a local review gallery."""
import html
import json
import struct
from pathlib import Path

root = Path('output/store-screenshots')
languages = ['ja', 'en', 'ko', 'zh-Hant', 'es', 'pt-BR', 'id']
files = []
for device, size in [('iphone', (1320, 2868)), ('iphone-duo', (1398, 2034))]:
    for language in languages:
        images = sorted((root / device / language).glob('*.png'))
        assert len(images) == 5, (device, language, len(images))
        for path in images:
            data = path.read_bytes()
            assert data[:8] == b'\x89PNG\r\n\x1a\n', path
            width, height, depth, color = struct.unpack('>IIBB', data[16:26])
            assert (width, height) == size, (path, width, height)
            assert color == 2 and depth == 8, (path, 'must be opaque RGB', color, depth)
            files.append({'path': str(path.relative_to(root)), 'width': width,
                          'height': height, 'bytes': len(data), 'language': language, 'device': device})
checks = json.loads((root / 'typography-checks.json').read_text())
assert all(x['fits'] for x in checks), 'Typography overflow'
(root / 'files.json').write_text(json.dumps(files, ensure_ascii=False, indent=2) + '\n')
parts = ['''<!doctype html><html lang="ja"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>TapReco スクリーンショット</title>
<style>body{margin:0;background:#efefec;font-family:system-ui,sans-serif;color:#222}header{padding:24px 4vw;background:white;position:sticky;top:0;z-index:1;border-bottom:1px solid #ddd}h1{font-size:20px;margin:0 0 10px}select{font:inherit;padding:7px;margin-right:10px}main{padding:20px 4vw}.row{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:14px}.row img{width:100%;display:block;box-shadow:0 3px 14px #0002}.row a{color:#555;text-decoration:none;font-size:12px}h2{font-size:18px;margin:32px 0 16px}@media(max-width:800px){.row{grid-template-columns:repeat(2,minmax(0,1fr))}}</style>
<header><h1>TapReco · 7言語 × 2端末 × 5枚</h1><select id="device"><option value="all">全端末</option><option value="iphone">iPhone</option><option value="iphone-duo">iPhone Duo</option></select><select id="language"><option value="all">全言語</option>''']
for language in languages:
    parts.append(f'<option value="{language}">{language}</option>')
parts.append('</select></header><main>')
for device in ['iphone', 'iphone-duo']:
    for language in languages:
        parts.append(f'<section data-device="{device}" data-language="{language}"><h2>{device} / {language}</h2><div class="row">')
        for f in files:
            if f['device'] == device and f['language'] == language:
                path = html.escape(f['path'])
                parts.append(f'<a href="{path}" target="_blank"><img src="{path}" loading="lazy" alt="{path}">{Path(path).name}</a>')
        parts.append('</div></section>')
parts.append('''</main><script>for(const field of document.querySelectorAll('select'))field.onchange=()=>{for(const row of document.querySelectorAll('section'))row.hidden=!((device.value==='all'||row.dataset.device===device.value)&&(language.value==='all'||row.dataset.language===language.value))}</script></html>''')
(root / 'index.html').write_text(''.join(parts))
print(f'Validated {len(files)} RGB PNGs and {len(checks)} text measurements; gallery created.')
