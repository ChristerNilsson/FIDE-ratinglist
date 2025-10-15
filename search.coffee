echo = console.log
range = _.range

members = {}


# https://chatgpt.com/s/t_68ee8d15b2508191b461f981e133a99b
fideCheckDigit = (numWithoutCheck) ->
	weights = [2,3,4,5,6,7]
	digits = (parseInt(d) for d in numWithoutCheck.toString())
	sum = 0
	for d, i in digits by -1
		w = weights[(digits.length - 1 - i) % 6]
		sum += d * w
	r = sum % 11
	c = (11 - r) % 11
	if c is 10 then 0 else c



fideIsValid = (fideNumber) ->
  num = Math.floor fideNumber / 10
  check = fideNumber % 10
  fideCheckDigit(num) is check

# Exempel
console.log fideCheckDigit 171035  # → 4
console.log fideIsValid 1710354    # → true
console.log fideIsValid 1710355    # → false




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
