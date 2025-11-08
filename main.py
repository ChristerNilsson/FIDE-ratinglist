# Hämtar alla Sveriges medlemmar via API från member.schack och sparar på ssf.json
# FIDE används ej pga av problem med åäö som inte går att fixa eftersom de ersattes med aao

import urllib.request
import json
import time

hash = {}
start = time.time()

def fetchSSF(month):
	url = f"https://member.schack.se/public/api/v1/ratinglist/federation/date/{month}-01/ratingtype/1/category/0"
	with urllib.request.urlopen(url) as response:
		return json.loads(response.read())

members = fetchSSF('2025-11')

ssf = {}
for member in members:
	ssfid = member['id']
	fideid = member['fideid']
	firstName = member['firstName']
	lastName = member['lastName']
	sex = member['sex']
	birthYear = int(member['birthdate'])
	elo = member['elo']
	classic = elo['rating']
	rapid = elo['rapidRating']
	blitz = elo['blitzRating']
	name = lastName + ', ' + firstName
	ssf[fideid] = [classic, rapid, blitz, ssfid, name, sex, birthYear]

with open('ssf.json', 'w', encoding='utf-8') as g:
	json.dump(ssf, g, ensure_ascii=False)

print(time.time()-start) # 2.85 sek => 9930 personer