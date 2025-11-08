import json
import time

hash = {}
start = time.time()

for i in range(1000):
	shard = str(i)
	if i<10: shard = "0" + shard
	if i<100: shard = "0" + shard
	hash[shard] = {}

def fetchFIDE():
	with open('fide.txt', 'r', encoding='utf-8') as f:
		lines = f.readlines()
		for line in lines[1:]:
			fideId = line[0:15].strip()
			name = line[15:75].strip()
			classic = int(line[113:117].strip())
			rapid = int(line[126:130].strip())
			blitz = int(line[139:143].strip())
			shard = fideId[-4:-1]
			h = hash[shard]
			h[fideId] = [classic,rapid,blitz,name]
	for i in range(1000):
		shard = str(i)
		if i < 10: shard = "0" + shard
		if i < 100: shard = "0" + shard
		with open('shards/' + shard + '.json', 'w', encoding='utf-8') as g:
			json.dump(hash[shard], g, ensure_ascii=False)

fetchFIDE()

print(time.time()-start)