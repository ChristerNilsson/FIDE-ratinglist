echo = console.log
range = _.range

SPEED = 0 # 0=Classic 1=Rapid 2=Blitz

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

	result = await members[fidenumber]
	echo result
	result

getRating = (member,speed) ->
	pref = [[0,1,2],[1,2,0],[2,1,0]][speed]
	for x in pref
		if member[x] > 0 then return member[x]
	return "0000"

koppla = (typ, parent, attrs = {}) ->
	elem = document.createElement typ

	if 'text' of attrs
		elem.textContent = attrs.text
		delete attrs.text

	if 'html' of attrs
		elem.innerHTML = attrs.html
		delete attrs.html

	for own key of attrs
		elem.setAttribute key, attrs[key]

	parent.appendChild elem
	elem

transfer = (speed, fidenumber) ->
	fidenumber = fidenumber.trim()
	if fidenumber == "" then return ""
	member = await fetchShard fidenumber
	echo member
	if member == undefined then return fidenumber
	rating = getRating member,speed
	name = member[3]
	fidenumber + ' ' + if rating == undefined or name == undefined then "" else rating + ' ' + name

update = ->
	updateRounds()
	updateSpeed()
	updateTimeEstimation()

updateRounds = ->
	rounds.disabled = types.value == "Berger"
	n = players.options?.length
	if types.value == "Berger"
		if n == 0 then rounds.selectedIndex = 0
		else
			if n %% 2 == 0
				rounds.selectedIndex = n - 1
			else 
				rounds.selectedIndex = n

updateSpeed = ->
	base = parseInt bases.value
	incr = parseInt incrs.value
	total = base + incr
	SPEED = 0 # Classic
	if total < 60 then SPEED = 1 # Rapid
	if total < 10 then SPEED = 2 # Blitz
	speed.textContent = ' ' + 'Classic Rapid Blitz'.split(' ')[SPEED]

updateTimeEstimation = ->
	base = parseInt bases.value
	incr = parseInt incrs.value
	total = base + incr
	count = parseInt rounds.value
	if double.value == 'double' then games = 2 else games = 1
	minutes = count * games * total * 2
	hours = minutes // 60
	minutes = minutes %% 60
	estimation.textContent = " #{hours} h #{minutes} m"

app = document.getElementById "app"

title = koppla "input", app, placeholder:'Title'
title.style.width = "286px"

div1 = koppla "div", app
types = koppla "select", div1
for type in 'Berger FairPair'.split ' '
	koppla "option", types, text:type
types.addEventListener "change", -> update()

div2 = koppla "div", app
bases = koppla "select", div2
for base in [1,2,3,4,5,10,15,25,30,45,60,90]
	koppla "option", bases, text:"#{base} min"
bases.addEventListener "change", -> update()

incrs = koppla "select", div2
for incr in [0,1,2,3,4,5,10,15,20,25,30]
	koppla "option", incrs, text:"#{incr} sec"
incrs.addEventListener "change", -> update()

speed = koppla "label", div2, text:" Classic"

div3 = koppla "div", app

rounds = koppla "select", div3, disabled:true
for r in range 21
	koppla "option", rounds, text:"#{r} rounds"
rounds.addEventListener "change", -> update()

double = koppla "select", div3
double.style.width = "75px"
koppla "option",double, text:"single"
koppla "option",double, text:"double"
double.addEventListener "change", -> update()

estimation = koppla "label", div3 #, text: " 3 h 27 m"

div4 = koppla "div",app
player = koppla "input", div4, placeholder:'FIDE id'
player.style.width = "80px"
player.addEventListener "keydown", (event) =>
	if event.key == "Enter" then ins.click()

ins = koppla "button", div4, text:'Insert'
ins.addEventListener 'click', -> 
	p = await transfer SPEED,player.value
	if p.length < 10 then return 
	koppla "option",players, text: p
	player.value = ""
	player.focus()
	playerCount.textContent = " #{players.options.length}"
	update()

del = koppla "button", div4, text:'Delete'
del.addEventListener 'click', -> 
	if players.options?.length == 0 then return 
	players.removeChild players.lastElementChild
	playerCount.textContent = " #{players.options.length}"
	update()

playerCount = koppla "label", div4, text: " 0"

players = koppla "select", app, size:20
koppla "option",players, text:1700057
koppla "option",players, text:1700111
koppla "option",players, text:1705300
koppla "option",players, text:1724738
koppla "option",players, text:1760025
players.style.width = "294px"
playerCount.textContent = " " + players.options?.length

types.selectedIndex = 1
bases.selectedIndex = 9
incrs.selectedIndex = 7
rounds.selectedIndex = 4
double.selectedIndex = 0

update()
