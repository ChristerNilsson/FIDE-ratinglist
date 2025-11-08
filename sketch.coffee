echo = console.log
range = _.range

TYPE = 0 # 0=Classic 1=Rapid 2=Blitz

members = {}

do ->
	try
		[res1] = await Promise.all [fetch('./ssf.json')]
		[members] = await Promise.all [res1.json()]
		echo members
		transfer TYPE
	catch err
		console.error 'Fel vid hämtning:', err

getRating = (member,type) ->
	if member[type] > 0 then return member[type]
	if member[type+1] > 0 then return member[type+1]
	if member[type+2] > 0 then return member[type+2]

transfer = (type) ->
	fidenumbers = textarea0.value.split "\n"
	result = []
	for fidenumber in fidenumbers
		if fidenumber.trim() == "" then continue
		member = if fidenumber not of members then ['saknas!',"0","0","0"] else members[fidenumber]
		rating = getRating member,type
		if rating == '0' then rating = "0000"
		name = member[4]
		result.push  fidenumber + ' ' + if rating != undefined and name != undefined then rating + ' ' + name else ''
	
	textarea1.value = result.join "\n"

textarea0.addEventListener 'input', (e) -> transfer TYPE
