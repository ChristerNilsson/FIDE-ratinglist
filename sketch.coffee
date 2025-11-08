echo = console.log
range = _.range

TYPE = 0 # 0=Classic 1=Rapid 2=Blitz

members = {}

fetchShard = (fidenumber) ->
	shard = "#{fidenumber}"
	n = shard.length
	shard = shard.slice n-4,n-1

	try
		filename = "./shards/#{shard}.json"
		response = await fetch filename
		members = await response.json()
	catch error 
		console.error 'Fel vid hämtning:', error

	return await members[fidenumber]


getRating = (member,type) ->
	if member[type] > 0 then return member[type]
	if member[type+1] > 0 then return member[type+1]
	if member[type+2] > 0 then return member[type+2]

transfer = (type) ->
	fidenumbers = textarea0.value.split "\n"
	result = []
	for fidenumber in fidenumbers
		fidenumber = fidenumber.trim()
		if fidenumber == "" then continue
		member = await fetchShard fidenumber
		member = if not member then ['saknas!',"0","0","0"] else member
		rating = getRating member,type
		if rating == '0' then rating = "0000"
		name = member[3]
		result.push  fidenumber + ' ' + if rating != undefined and name != undefined then rating + ' ' + name else ''
	
	textarea1.value = result.join "\n"

textarea0.addEventListener 'input', (e) -> transfer TYPE
