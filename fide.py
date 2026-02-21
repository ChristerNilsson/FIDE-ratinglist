import json
import time

hash = {}
start = time.time()

def fetchFIDE():
	with open('players_list_foa.txt', 'r', encoding='utf-8') as f:
		lines = f.readlines()
		for line in lines[1:]:
			fideId = line[0:15].strip()
			name = line[15:75].strip()

			classic = int(line[113:117].strip())
			rapid = int(line[126:130].strip())
			blitz = int(line[139:143].strip())

			if classic == 0 and rapid == 0 and blitz == 0: continue

			shard = fideId[0:3]

			if shard not in hash: hash[shard] = {}
			h = hash[shard]
			h[fideId] = [classic,rapid,blitz,name]
	for key in hash:
		shard = key
		while len(shard) < 3: shard = "0" + shard
		with open('shards/' + shard + '.json', 'w', encoding='utf-8') as g:
			json.dump(hash[shard], g, ensure_ascii=False)

fetchFIDE()

print(time.time()-start)