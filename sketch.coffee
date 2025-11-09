echo = console.log
range = _.range

BASE = 45
INCR = 15

total = BASE + INCR

TYPE = 2 # Blitz
if total >= 10 then TYPE = 1 # Rapid
if total >= 60 then TYPE = 0 # Classic

members = {}

fetchShard = (fidenumber) ->
	shard = "#{fidenumber}"
	n = shard.length
	if n < 7 then return ""
	shard = shard.slice n-4,n-1

	try
		filename = "./shards/#{shard}.json"
		response = await fetch filename
		members = await response.json()
	catch error 
		console.error 'Fel vid hämtning:', error

	return await members[fidenumber]

getRating = (member,type) ->
	pref = [[0,1,2],[1,2,0],[2,1,0]][type]
	for x in pref
		if member[x] > 0 then return member[x]
	return "0000"

transfer = (type) ->
	fidenumbers = textarea0.value.split "\n"
	result = []
	for fidenumber in fidenumbers
		fidenumber = fidenumber.trim()
		if fidenumber == "" then
			result.push ""
		else
			member = await fetchShard fidenumber
			if member == undefined
				result.push fidenumber
			else
				rating = getRating member,type
				name = member[3]
				result.push fidenumber + ' ' + if rating == undefined or name == undefined then "" else rating + ' ' + name
	
	textarea1.value = result.join "\n"

textarea0.addEventListener 'input', (e) -> transfer TYPE
