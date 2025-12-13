import urllib.request
import json
import time

hash = {}
start = time.time()

def fetchClub(clubid,month):
	url = f"https://member.schack.se/public/api/v1/ratinglist/club/{clubid}/date/{month}-01/ratingtype/1/category/0"
	with urllib.request.urlopen(url) as response:
		members = json.loads(response.read())

	result = []
	for member in members:
		clubId = member['clubId']
		if clubid != clubId: continue
		club = member['club']
		fideid = member['fideid']
		if fideid == 0: continue
		firstName = member['firstName']
		lastName = member['lastName']
		birthYear = int(member['birthdate'])
		name = lastName + ' ' + firstName
		elo = member['elo']
		result.append(f"{fideid};{lastName};{firstName};{club};SWE;M;{birthYear};{elo['rating']};{elo['rating']}")
	result.sort()

	with open('clubs/' + club + '.txt', 'w', encoding='utf-8') as g:
		g.write("FIDE-No;surname;first name;Club;Fed;Sex;Birth;Rating nat;Rating int\n")
		g.write('\n'.join(result))

# Dessa är de enda som fungerar:
"No, surname, first name, Title, FIDE-No, ID no, Rating nat, Rating int, Birth, Fed, Sex, Type, Gr, Clubno, Club, Name, Captain, Board"

month = '2025-12'
for clubid in [40628,38453,38454,38455,38456,38457,38658,39958,38460,38462,38464,38468,38472,38470,38469,38476,38477,38478,38447,38479,38480,38481]:
	fetchClub(clubid,month)

print(round(time.time()-start,3))