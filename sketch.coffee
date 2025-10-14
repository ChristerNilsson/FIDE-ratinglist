echo = console.log
range = _.range

TYPE = 1 # 1=Standard 2=Rapid 3=Blitz

pretty = {}
members = {}

do ->
	try
		[res1, res2] = await Promise.all [fetch('./pretty.json'), fetch('./databas.json')]
		[pretty, members] = await Promise.all [res1.json(), res2.json()]
		transfer TYPE
	catch err
		console.error 'Fel vid hämtning:', err

getRating = (member,type) ->
	if member[type] > 0 then return member[type]
	if member[type-1] > 0 then return member[type-1]
	if member[type-2] > 0 then return member[type-2]

transfer = (type) ->
	fidenumbers = textarea0.value.split "\n"
	result = []
	for fidenumber in fidenumbers
		if fidenumber.trim() == "" then continue
		member = if fidenumber not of members then ['saknas!',"0","0","0"] else members[fidenumber]
		rating = getRating member,type
		if rating == '0' then rating = "0000"
		name = if fidenumber of pretty then pretty[fidenumber] else member[0]
		result.push rating + ' ' + name
	
	textarea1.value = result.join "\n"

textarea0.addEventListener 'input', (e) -> transfer TYPE

save.addEventListener 'click', (e) -> 
	s = textarea0.value.trim().split '\n'
	t = textarea1.value.trim().split '\n'
	downloadFile 'turnering.txt', (s[i] + ' ' + t[i] for i in range s.length).join '\n'

downloadFile = (filename, content, mime='text/plain') ->
	blob = new Blob [content], {type: mime}  # eller 'application/json' etc
	url = URL.createObjectURL blob
	a = document.createElement 'a'
	a.href = url
	a.download = filename
	document.body.appendChild a
	a.click()
	a.remove()
	setTimeout (-> URL.revokeObjectURL url), 0
