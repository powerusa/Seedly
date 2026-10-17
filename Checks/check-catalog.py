"""Check catalog IDs, bundled photo files, image decoding and new-photo licenses."""
import collections,json,pathlib,re,subprocess
root=pathlib.Path(__file__).resolve().parents[1]/'Seedly'
entries=[]
for name in ['PlantDatabase.swift','PlantDataExpansion.swift','PlantDatabaseFull.swift','PlantCatalogAdditions.swift']:
    text=(root/'Services'/name).read_text()
    entries+=list(zip(re.findall(r'\bid: "([^"]+)"',text),re.findall(r'imageAssetName: "([^"]+)"',text)))
assert len(entries)==77 and len(set(i for i,_ in entries))==77
for plant,asset in entries:
    folder=root/'Resources/Assets.xcassets'/(asset+'.imageset')
    data=json.loads((folder/'Contents.json').read_text())
    files=[folder/item['filename'] for item in data['images'] if item.get('filename')]
    assert files and all(f.is_file() for f in files),plant
    for file in files:
        check=subprocess.run(['sips','-g','pixelWidth','-g','pixelHeight',str(file)],capture_output=True,text=True)
        assert check.returncode==0 and 'pixelWidth: <nil>' not in check.stdout,plant
credits=json.loads((root/'Resources/PlantPhotoCredits.json').read_text())
assert len(credits)==10 and len({c['plantId'] for c in credits})==10
for credit in credits:
    assert credit['author'] and credit['source'] and credit['license'] and credit['changes']
    assert credit['license'] in ['CC0','Public domain'] or (credit['license'].startswith('CC BY') and credit['licenseURL'])
print('PASS: 77/77 plants have decodable bundled photos; all 10 added photos have attribution and accepted licenses')
