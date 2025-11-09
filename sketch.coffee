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

updateSpeed = ->
	base = parseInt bases.value
	incr = parseInt incrs.value
	total = base + incr
	SPEED = 0 # Classic
	if total < 60 then SPEED = 1 # Rapid
	if total < 10 then SPEED = 2 # Blitz
	speed.textContent = ' ' + 'Classic Rapid Blitz'.split(' ')[SPEED]

app = document.getElementById "app"

title = koppla "input", app, placeholder:'Title'
title.style.width = "286px"

div2 = koppla "div", app
bases = koppla "select", div2
for base in [1,2,3,4,5,10,15,25,30,45,60,90]
	koppla "option", bases, text:"#{base} min"
bases.addEventListener "change", -> updateSpeed()
bases.selectedIndex = 9

incrs = koppla "select", div2
for incr in [0,1,2,3,4,5,10,15,20,25,30]
	koppla "option", incrs, text:"#{incr} sec"
incrs.addEventListener "change", -> updateSpeed()
incrs.selectedIndex = 7

speed = koppla "label", div2, text:" Classic"

div3 = koppla "div", app

rounds = koppla "select",div3
for r in range 3,21
	koppla "option", rounds, text:"#{r} rounds"
rounds.selectedIndex = 4

double = koppla "select", div3
double.style.width = "75px"
koppla "option",double, text:"single"
koppla "option",double, text:"double"
double.selectedIndex = 0

div = koppla "div",app
player = koppla "input", div, placeholder:'FIDE id'
player.style.width = "166px"
player.addEventListener "keydown", (event) =>
	if event.key == "Enter" then ins.click()

ins = koppla "button", div, text:'Insert'
ins.addEventListener 'click', -> 
	start = new Date()
	koppla "option",players, text: await transfer SPEED,player.value
	player.value = ""
	player.focus()
	stopp = new Date()
	echo stopp - start

del = koppla "button", div, text:'Delete'
del.addEventListener 'click', -> 
	if players.options?.length == 0 then return 
	players.removeChild players.lastElementChild

players = koppla "select", app, size:20
players.style.width = "294px"
players.style.fontFamily = "monospace"
