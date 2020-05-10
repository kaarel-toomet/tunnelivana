extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var inventory = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
				-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1]
export var amounts = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0]
var select = 0
var empty = 0

#block ids:
#0:sand, 1:sea, 2:grass, 3:box, 4:stone, 5:snow, 6:deep sea
#7:tree, 8:cactus, 9:snowy ground, 10:spruce, 11:peat moss, 12:jungle
#13:tundra, 14:sea ice, 15:acacia

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
var blocks
var hotbar

var kuld = 0
var kolliv = 0


signal ehitadasaab(block)
signal lammutadasaab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	none.load("assets/none.png")
	liiv.load("assets/asdfblock.png")
	meri.load("assets/sky.png")
	muru.load("assets/ground.png")#.expand_x2_hq2x()
	kast.load("assets/kast.png")#.expand_x2_hq2x()
	kivi.load("assets/asdfback.png")#.expand_x2_hq2x()
	lumi.load("assets/☃.png")#.expand_x2_hq2x()
	sygavm.load("assets/deepw.png")#.expand_x2_hq2x()
	puu.load("assets/puu.png")#.expand_x2_hq2x()
	kaktus.load("assets/kaktus.png")#.expand_x2_hq2x()
	lmaa.load("assets/luminemaa.png")#.expand_x2_hq2x()
	kuusk.load("assets/kuusk.png")#.expand_x2_hq2x()
	tsammal.load("assets/turbasammal.png")
	jungle.load("assets/jungle.png")#.expand_x2_hq2x()
	tundra.load("assets/tundra.png")#.expand_x2_hq2x()
	mjxx.load("assets/seaice.png")#.expand_x2_hq2x()
	akaatsia.load("assets/acacia.png")#.expand_x2_hq2x()
	puit.load("assets/wood.png")
	kuldp.load("assets/goldblock.png")
	kollivp.load("assets/kollivaremed.png")
	
	
	blocks = [liiv,meri,muru,kast,kivi,lumi,sygavm,puu,kaktus,
				lmaa,kuusk,tsammal,jungle,tundra,mjxx,akaatsia,puit,
				kuldp, kollivp, none]
	#print(tsammal)
	hotbar = Image.new()
	hotbar.load("assets/hotbar.png")
	

func get(item):
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
		if block == 7 or block == 10 or block == 12 or block == 15:
			amounts[select] -= 1
			get(16)
		if block == 16:
			amounts[select] -= 1
			get(3)
			
	if kuld >= 10 and (empty < 20 or inventory.has(17)):
		kuld -= 10
		get(17)
	if kolliv >= 10 and (empty < 20 or inventory.has(18)):
		kolliv -= 10
		get(18)
			


func _on_TileMap_ehitus():
	if amounts[select] > 0:
		emit_signal("ehitadasaab", inventory[select])


func _on_TileMap_lammutus(blockbroken):
	if blockbroken == 0: return
	if blockbroken == 1: return
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
