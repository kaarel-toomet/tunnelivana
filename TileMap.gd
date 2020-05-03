extends TileMap

export (PackedScene) var kuld

#var persistencenoise = OpenSimplexNoise.new()#noises used by worldgen
var mainnoise = OpenSimplexNoise.new()
#var continentnoise = OpenSimplexNoise.new()
#var tempnoise = OpenSimplexNoise.new()
#var wetnoise = OpenSimplexNoise.new()
#var largetempnoise = OpenSimplexNoise.new()
#var largewetnoise = OpenSimplexNoise.new()
#var rivetrnoise = OpenSimplexNoise.new()

export var chunkW = 15 #when changing these, change the numbers in hullmyts's script, that are used in the changechunk signal
export var chunkH = 10

var wOffsetx = -1 # activewindow offset, top-left chunk in tiles
var wOffsety = -1


signal lammutus(blockbroken)
signal ehitus
signal jahsaabehitada
var mxy
var paused = false

"""
block adding checklist
1.add image to assets folder
2.add to tileset
3.add to breakto
4.add to ID comment
5.add image and image load to HUD script
6.add to blocks dict in HUD script
"""

var breakto = {-1:-1, 0:-1, 1:-1, 2:-1, 3:-1, 4:-1, 5:-1,
	6:-1, 7:-1, 8:-1, 9:-1, 10:-1, 11:-1, 12:-1, 13:-1,
	14:-1, 15:-1, 16:-1, 17:-1, 18:-1}
#255:nothimg, 0:sand, 1:sea, 2:grass, 3:box, 4:stone, 5:snow, 6:deep sea
#7:tree, 8:cactus, 9:snowy ground, 10:spruce, 11:peat moss, 12:jungle
#13:tundra, 14:sea ice, 15:acacia, 16:wood, 17:gold, 18:monster ruins

func generate(cx,cy):
	if $generated.get_cell(cx,cy) != -1:
		return
	$generated.set_cell(cx,cy,0)
	for x in range(chunkW*cx,chunkW*(cx+1)):
		for y in range(chunkH*cy,chunkH*(cy+1)):
			var gencell = -1
			#var offsetval = pow(abs(continentnoise.get_noise_2d(x,y)),0.3) * sign(continentnoise.get_noise_2d(x,y))
			var noiseval = mainnoise.get_noise_2d(x,y)*30+y   #+offsetval*0.6
			#var heatval = tempnoise.get_noise_2d(x,y) + largetempnoise.get_noise_2d(x,y)
			#var moistureval = wetnoise.get_noise_2d(x,y) + largewetnoise.get_noise_2d(x,y)
			#var heatthresholdlow = rand_range(-0.35,-0.15)
			#var heatthresholdhigh = rand_range(0.15,0.35)
			#var moisturethresholdlow = rand_range(-0.35,-0.15)
			#var moisturethresholdhigh = rand_range(0.15,0.35)
			#var heat
			#var moisture
			#mainnoise.persistence = abs(persistencenoise.get_noise_2d(x+1000,y)*1.2)+0.4
			#var rivetrval = abs(rivetrnoise.get_noise_2d(x,y))
			#3if heatval < heatthresholdlow: # make heat simpler
			#	heat = 0
			#elif heatval < heatthresholdhigh:
			#	heat = 1
		#	else:
		#		heat = 2
		##	if moistureval < moisturethresholdlow:# make moisture simpler
			#	moisture = 0
		#	elif moistureval < moisturethresholdhigh:
		#		moisture = 1
	#		else:
			#	moisture = 2
			if noiseval > 0: # deep sea
				gencell = 4
				if get_cell(x,y-1) == -1:
					set_cell(x,y,2)
			if mainnoise.get_noise_2d(x,y-1)*30+y-1 > 0:
				set_cell(x,y,gencell)
				
			#if randi() % 1000 == 0:
				#var spawn = kuld.instance()
				#get_parent().get_node("kullad").add_child(spawn)
				#spawn.position = Vector2(x*32,y*32)
				#spawn.scale = Vector2(2,2)
				
func lammuta(x,y):
	x = floor(x)
	y = floor(y)
	if get_cell(x,y) == -1:
		return
	set_cell(x,y,breakto[get_cell(x,y)])
	if randi() % 100 == 0:
		var spawn = kuld.instance()
		get_parent().get_node("kullad").add_child(spawn)
		spawn.position = Vector2(x*32+16,y*32+16)
		spawn.scale = Vector2(2,2)


func save_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.WRITE)
	for chunk in $generated.get_used_cells():
		chunks.store_double(chunk.x)
		chunks.store_double(chunk.y)
		for x in range(chunkW):
			for y in range(chunkH):
				chunks.store_8(get_cell(x+chunk.x*chunkW, y+chunk.y*chunkH))
	chunks.close()
	var data := File.new()
	data.open("res://world/data.gwrld",File.WRITE)
	data.store_8(get_parent().get_node("hullmyts").health)
	data.store_8(get_parent().get_node("hud").kuld)
	data.store_8(get_parent().get_node("hud").kolliv)
	for s in range(20):
		data.store_8(get_parent().get_node("hud").inventory[s])
		data.store_16(get_parent().get_node("hud").amounts[s])
	#data.store_double(get_parent().get_node("hullmyts").position[0])
	#data.store_double(get_parent().get_node("hullmyts").position[1])
	data.close()
	
func load_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.READ)
	
	if chunks.file_exists("res://world/chunks.gwrld"):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_double()
			chunk.y = chunks.get_double()
			for x in range(chunkW):
				for y in range(chunkH):
					set_cell(x+chunk.x*chunkW,y+chunk.y*chunkH,chunks.get_8())
		chunks.close()
		
	else:
		print("chunks file not found")
		
	var data := File.new()
	data.open("res://world/data.gwrld",File.READ)
	if data.file_exists("res://world/data.gwrld"):
		get_parent().get_node("hullmyts").health = data.get_8()
		get_parent().get_node("hud").kuld = data.get_8()
		get_parent().get_node("hud").kolliv = data.get_8()
		for s in range(20):
			get_parent().get_node("hud").inventory[s] = data.get_8()
			get_parent().get_node("hud").amounts[s] = data.get_16()
	else:
		print("data file not found")
	data.close()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	
	#persistencenoise.seed = 434
	#persistencenoise.octaves = 4
	#persistencenoise.period = 500
	#persistencenoise.persistence = 0.5
	#persistencenoise.lacunarity = 2
	
	#continentnoise.seed = 222
	#continentnoise.octaves = 5
	#continentnoise.period = 1000
	#continentnoise.persistence = 0.5
	#continentnoise.lacunarity = 2
	
	mainnoise.seed = 32
	mainnoise.octaves = 5
	mainnoise.period = 40
	mainnoise.persistence = 0.5
	mainnoise.lacunarity = 2
	
	#tempnoise.seed = 10
	#tempnoise.octaves = 5	
	#tempnoise.period = 300
	#tempnoise.persistence = 0.5		
	#tempnoise.lacunarity = 2
		
	#wetnoise.seed = 123
	#wetnoise.octaves = 5
	#wetnoise.period = 300
	#wetnoise.persistence = 0.5
	#wetnoise.lacunarity = 2
	
	#largetempnoise.seed = 100
	#largetempnoise.octaves = 5
	#largetempnoise.period = 4000
	#largetempnoise.persistence = 0.5
	#largetempnoise.lacunarity = 2
	
	#largewetnoise.seed = 1234
	#largewetnoise.octaves = 5
	#largewetnoise.period = 4000
	#largewetnoise.persistence = 0.5
	#largewetnoise.lacunarity = 2
	
	#rivetrnoise.seed = 7
	#rivetrnoise.octaves = 9
	#rivetrnoise.period = 500
	#rivetrnoise.persistence = 0.5
	#rivetrnoise.lacunarity = 2
	
	scroll(0,0)
	load_world()##################################################Rtrrrrre
	fix_invalid_tiles()
	
func scroll(sx,sy):
	#for cx in range(3):
		#for cy in range(3):
			#for x in range(chunkW*(cx+wOffsetx),chunkW*(cx+wOffsetx+1)):
				#for y in range(chunkH*(cy+wOffsety),chunkH*(cy+wOffsety+1)):
					#pass#set_cell(x,y,-1)
					#fix_invalid_tiles()
	for cx in range(3):
		for cy in range(3):
			generate(cx + wOffsetx + sx, cy + wOffsety + sy)
	wOffsetx += sx
	wOffsety += sy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if paused:
		return
	var parent = get_parent()
	mxy = parent.get_global_mouse_position()/32
	var hxy = parent.get_node("hullmyts").position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(hxy+Vector2(16,16), mxy*32-(mxy*32-hxy).normalized()*30, [parent.get_node("hullmyts")])
	if Input.is_action_just_pressed("LCLICK") and (not result):
		emit_signal("lammutus",get_cell(floor(mxy[0]),floor(mxy[1])))
	if Input.is_action_just_pressed("RCLICK") and (not result):
		emit_signal("ehitus")
func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		save_world()


func _on_hullmyts_changechunk(changex, changey):
	scroll(changex, changey)


func _on_hud_ehitadasaab(block):
	if get_cell(floor(mxy[0]),floor(mxy[1])) == breakto[block]:
		set_cell(floor(mxy[0]),floor(mxy[1]),block)
		emit_signal("jahsaabehitada")

func _on_hud_lammutadasaab():
	lammuta(get_parent().get_node("hullmyts").position[0]/32,get_parent().get_node("hullmyts").position[1]/32)


func _on_main_pause():
	paused = !paused
