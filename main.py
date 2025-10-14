import json

hash = {}

with open('players_list_foa.txt','r') as f:
	lines = f.readlines()
	for line in lines:
		# if 'SWE' in line:
		fide = line[0:10].strip()
		name = line[15:50].strip()
		S = line[114-1:118-1].strip()
		R = line[127-1:131-1].strip()
		B = line[140-1:144-1].strip()
		hash[fide] = [name,S,R,B]

with open('databas_world.json', 'w', encoding='utf-8') as f:
	json.dump(hash, f, ensure_ascii=False,separators=(',', ':'))
