extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pausemenu = preload("res://pause_menu.tscn")

export var inventory = [1,2,-1,-1,-1,-1,-1,-1,-1,-1,
						-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1]
export var amounts = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0]

var select = 0
var empty = 0

#block ids:
#255:nothimg, 0:air, 1:water, 2:grass, 3:sand, 4:stone, 5:log, 6:leaves
#7:coal bush, 8:pear, 9:water buffer, 10:tree seed, 11:unused, 12:aluminium
#13:bauxite, 14:waterfall, 15:waterfall buffer, 16:wood, 17:gold, 18:monster ruins,
#19:box, 20:algae, 21:onion, 22:onion seed, 23:pearman sculpture
#24:fire, 25:clay, 26:fired clay, 27:glass, 28:pickaxe, 29:sword

var none = Image.new()
var liiv = Image.new()
var meri = Image.new()
var muru = Image.new()
var kast = Image.new()
var kivi = Image.new()
var lumi = Image.new()
var sygavm = Image.new()
var puu = Image.new()
var kaktus = Image.new()
var lmaa = Image.new()
var kuusk = Image.new()
var tsammal = Image.new()
var jungle = Image.new()
var tundra = Image.new()
var mjxx = Image.new()
var akaatsia = Image.new()
var puit = Image.new()
var kuldp = Image.new()
var kollivp = Image.new()
var kast2 = Image.new()
var algae = Image.new()
var sibul = Image.new()
var sibulseed = Image.new()
var pearmansculpt = Image.new()
var tuli = Image.new()
var savi = Image.new()
var psavi = Image.new()
var klaas = Image.new()
var kirka = Image.new()
var mqqk = Image.new()
var lamp = Image.new()

var opaused = false

var blocks
var hotbar
var impdir

var onion = preload("res://onion.tscn")

var kuld = 0
var kolliv = 0

var time = 0


signal ehitadasaab(block)
signal lammutadasaab

# Called when the node enters the scene tree for the first time.
func _ready():
	#if none.load("res://.import/none.png") == OK:
	#	impdir = "res://.import"
	#else:
	impdir = "res://assets"
	none.load(impdir + "/none.png")
	liiv.load(impdir + "/asdfblock.png")
	meri.load(impdir + "/sky.png")
	muru.load(impdir + "/ground.png")#.expand_x2_hq2x()
	kast.load(impdir + "/kast.png")#.expand_x2_hq2x()
	kivi.load(impdir + "/asdfback.png")#.expand_x2_hq2x()
	lumi.load(impdir + "/☃.png")#.expand_x2_hq2x()
	sygavm.load(impdir + "/deepw.png")#.expand_x2_hq2x()
	puu.load(impdir + "/puu.png")#.expand_x2_hq2x()
	kaktus.load(impdir + "/kaktus.png")#.expand_x2_hq2x()
	lmaa.load(impdir + "/luminemaa.png")#.expand_x2_hq2x()
	kuusk.load(impdir + "/kuusk.png")#.expand_x2_hq2x()
	tsammal.load(impdir + "/turbasammal.png")
	jungle.load(impdir + "/jungle.png")#.expand_x2_hq2x()
	tundra.load(impdir + "/tundra.png")#.expand_x2_hq2x()
	mjxx.load(impdir + "/seaice.png")#.expand_x2_hq2x()
	akaatsia.load(impdir + "/acacia.png")#.expand_x2_hq2x()
	puit.load(impdir + "/wood.png")
	kuldp.load(impdir + "/goldblock.png")
	kollivp.load(impdir + "/kollivaremed.png")
	kast2.load(impdir + "/turbasammal.png")
	algae.load(impdir + "/vetikas.png")
	sibul.load(impdir + "/sibul.png")
	sibulseed.load(impdir + "/sibulaseeme.png")
	pearmansculpt.load(impdir + "/pearman.png")
	tuli.load(impdir + "/tuli.png")
	savi.load(impdir + "/savi.png")
	psavi.load(impdir + "/psavi.png")
	klaas.load(impdir + "/glass.png")
	kirka.load(impdir + "/pickaxe.png")
	mqqk.load(impdir + "/sword.png")
	lamp.load(impdir + "/lamp.png")
	
	blocks = [liiv,meri,muru,kast,kivi,lumi,sygavm,puu,kaktus,
				lmaa,kuusk,tsammal,jungle,tundra,mjxx,akaatsia,puit,
				kuldp, kollivp, kast2, algae, sibul, sibulseed,
				pearmansculpt, tuli, savi, psavi, klaas,
				kirka, mqqk, lamp, none]
	#print(tsammal)
	hotbar = Image.new()
	hotbar.load(impdir + "/hotbar.png")
	

func collect(item):
	if inventory.has(item):
		amounts[inventory.find(item)] += 1
	else:
		inventory[empty] = item
		amounts[empty] = 1


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				select -= 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				select += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().paused and !opaused:
		var menu = pausemenu.instance()
		add_child(menu)
	opaused = get_parent().paused
	if get_parent().paused: return
	time += delta
	get_parent().get_node("TileMap/light").sl = int(sin(time/100)*10+3.5)
	#if -sin(time*0.02) > 0:
		#get_parent().sf = 5
	#else:
		#get_parent().sf = 0
	
	$goldtext.text = str(kuld)
	$kollivtext.text = str(kolliv)
	
	if select > 19:
		select = 0
	if select < 0:
		select = 19
	var hotbarnew = hotbar
	
	for s in range(20):
		if inventory[s] == 255:
			inventory[s] = -1
		hotbarnew.blit_rect(blocks[inventory[s]], Rect2(0,0,32,32),Vector2(1+s*18,1))
		
		var texture = ImageTexture.new()
		texture.create_from_image(hotbarnew)
		texture.set_flags(2)
		$hotbar.texture = texture
		if inventory[s] == -1:
			amounts[s] = 0
		if amounts[s] == 0:
			inventory[s] = -1
			
	inventory[20] = -1
	$Node2D.update()
	
	empty = inventory.find(-1)
	$selslot.position = Vector2(select*36+18,18)
	
	if Input.is_action_just_pressed("craft"):
		var block = inventory[select]
		if block == 5:# or block == 10 or block == 12 or block == 15:
			amounts[select] -= 1
			collect(16)
			collect(16)
		if block == 7 or block == 8:
			amounts[select] -= 1
			get_parent().get_node("hullmyts").health += 1
		if block == 6 and amounts[select] >= 7:
			amounts[select] -= 7
			collect(10)
		#if block == 13:# or block == 10 or block == 12 or block == 15:
			#amounts[select] -= 1
			#collect(12)
		if block == 16:
			amounts[select] -= 1
			collect(19)
		if block == 21:
			amounts[select] -= 1
			collect(22)
		if block == 12:
			amounts[select] -= 1
			collect(28)
		if block == 28:
			amounts[select] -= 1
			collect(29)
		if block == 29:
			amounts[select] -= 1
			collect(28)
		if block == 4 and inventory.has(6) and amounts[inventory.find(6)] >= 3 and amounts[select] >= 5:
			amounts[select] -= 5
			amounts[inventory.find(6)] -= 3
			collect(23)
	if Input.is_action_just_pressed("yeet") and inventory[select] == 21:
		amounts[select] -= 1
		var mxy = get_parent().get_global_mouse_position()#/32
		var pew = onion.instance()
		get_parent().get_node("sibulad").add_child(pew)
		pew.position = get_parent().get_node("hullmyts").position
		pew.vel = (mxy-get_parent().get_node("hullmyts").position).normalized() * 12
		pew.scale = Vector2(2,2)
		
		
	if kuld >= 10 and (empty < 20 or inventory.has(17)):
		kuld -= 10
		collect(17)
	if kolliv >= 10 and (empty < 20 or inventory.has(18)):
		kolliv -= 10
		collect(18)
			


func _on_TileMap_ehitus():
	if amounts[select] > 0:
		emit_signal("ehitadasaab", inventory[select])


func _on_TileMap_lammutus(blockbroken):
	if !get_parent().get_node("TileMap").solid.has(blockbroken): return
	if empty < 20 or inventory.has(blockbroken):
		#if blockbroken == 6:
			#return
		emit_signal("lammutadasaab")
		
		if inventory.has(blockbroken):
			amounts[inventory.find(blockbroken)] += 1
		else:
			inventory[empty] = blockbroken
			amounts[empty] += 1
		


func _on_TileMap_jahsaabehitada():
	amounts[select] -= 1
