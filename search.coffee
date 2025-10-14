echo = console.log
range = _.range

members = {}

do ->
	try
		res1 = await fetch('./databas.json') 
		members = await res1.json()
	catch err
		console.error 'Fel vid hämtning:', err

# 0 name
# 1 S
# 2 R
# 3 B
# 4 born
# 5 country

find = ->
	fragments = if name.value then name.value.split ' ' else []
	echo fragments.length
	year = born.value || ""
	land = country.value || ""
	echo year
	result = []
	for key of members
		member = members[key]
		antal = 0

		for fragment in fragments
			if member[0].includes fragment then antal++
		if antal < fragments.length then continue

		if not "#{member[4]}".startsWith year then continue
		if not "#{member[5]}".startsWith land then continue

		result.push key + ' ' + member[0]
		count.innerText = result.length
		if result.length >= 1000 then break

	result.push
	textarea1.value = result.join '\n'

name = document.getElementById "name"
born = document.getElementById "born"
count = document.getElementById "count"
country = document.getElementById "country"
answer = document.getElementById "textarea1"

name.addEventListener 'input', (e) -> find()
born.addEventListener 'input', (e) -> find()
country.addEventListener 'input', (e) -> find()
