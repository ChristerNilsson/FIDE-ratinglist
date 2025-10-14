import json

hash = {}

with open('players_list_foa.txt','r') as f:
	lines = f.readlines()[1:]
	for line in lines:
		fide = line[0:10].strip()
		name = line[15:50].strip()
		country = line[76:79].strip()
		S = int(line[114-1:118-1].strip())
		R = int(line[127-1:131-1].strip())
		B = int(line[140-1:144-1].strip())
		if country == 'SWE' or S >= 2000:
			hash[fide] = [name,S,R,B]

with open('databas.json', 'w', encoding='utf-8') as f:
	lines = [f'"{key}": {json.dumps(hash[key])}' for key in hash]
	f.write('{\n' + ',\n'.join(lines) + '\n}')
