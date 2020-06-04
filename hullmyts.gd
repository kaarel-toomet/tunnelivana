extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size  # Size of the game window.
var basespeed = 5
var speed = basespeed
var pause = false
export (PackedScene) var kuld

export var spawnpoint = Vector2(0,-256)

var breaking = true

var break0 = preload("res://assets/break0.png")
var break1 = preload("res://assets/break1.png")
var break2 = preload("res://assets/break2.png")
var break3 = preload("res://assets/break3.png")
var break4 = preload("res://assets/break4.png")
var breaktxts = [break0,break1,break2,break3,break4,break0]

var breakprg = 0
var breakpos = Vector2(0,0)
var breakspd = 5
var breakspds = [1,1,5,5,10,7,5,5,5,0,1,0,20,15,1,
				0,7,12,12,10,3,1,1,100,1,7,10,10,1,1,100]

# block IDs
#0:air, 1:water, 2:grass, 3:sand, 4:stone, 5:log, 6:leaves
#7:coal bush, 8:pear, 9:water buffer, 10:tree seed, 11:unused, 12:aluminium
#13:bauxite, 14:waterfall, 15:waterfall buffer, 16:wood, 17:gold, 18:monster ruins,
#19:box, 20:algae, 21:onion, 22:onion seed, 23:pearman sculpture
#24:fire, 25:clay, 26:fired clay, 27:glass, 28:pickaxe, 29:sword

var left = false
var right = false
var up = false
var down = false

var chunkW = 15 # change these with the chunk sizes in tilemap.gd
var chunkH = 10

var immunity = 0
var attacked = false

export var health = 1099999999999

var oldpos = position
var fast = false
var yvel = 0
var onG = false
var swim = false

var oxy = 10


signal changechunk



# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 0#chunkW*48
	position.y = 0#chunkH*48


#Calledeveryframe.'delta'istheelapsedtimesincethepreviousframe.
func _process(delta):
	if get_parent().paused: return
	
	if get_parent().get_node("TileMap").get_cellv(position/32) == 1 or get_parent().get_node("TileMap").get_cellv(position/32) == 14:
		swim = true
		speed = basespeed/2
	else:
		swim = false
		speed = basespeed
	
	var oldpos = position
	if Input.is_action_just_pressed("LSHIFT"):
		fast = true
	if Input.is_action_just_released("LSHIFT"):
		fast = false
	fast = true
	
	for i in get_slide_count():
		var c = get_slide_collision(i)
		var tilemap = get_parent().get_node("TileMap")
		#if c.collider != tilemap:
			#return
		var pos = Vector2(floor((position[0]+16)/32),floor((position[1]+16)/32))-c.normal
		
		tilemap.pcol = pos
		breakpos = pos
		
		if c.normal.x == -1 and right and breaking:
			breakprg += 60*delta
			
		elif c.normal.x == 1 and left and breaking:
			breakprg += 60*delta
			
		elif c.normal.y == -1 and down and breaking:
			breakprg += 60*delta
			
		elif c.normal.y == 1 and up and breaking:
			breakprg += 60*delta
		breakpos = pos*32
		breakspd = breakspds[tilemap.get_cellv(pos)]
		if get_parent().get_node("hud").inventory[get_parent().get_node("hud").select] == 28:
			breakspd = breakspd * 0.1
		breakspd *= 1+get_parent().difficulty*0.4
		if floor(breakprg/breakspd) >= 5:
			tilemap.emit_signal("lammutus",tilemap.get_cellv(pos))
			breakprg = 0
		#if get_parent().get_node("TileMap").get_cellv(pos) in get_parent().get_node("TileMap").solid:
			#get_parent().get_node("TileMap").pcol = pos
			#get_parent().get_node("TileMap").emit_signal("lammutus",get_parent().get_node("TileMap").get_cellv(pos))
	
	
		#fast = false
		
	if not fast:
		left = Input.is_action_just_pressed("ui_left")
		right = Input.is_action_just_pressed("ui_right")
		up = Input.is_action_pressed("ui_up")
		down = Input.is_action_just_pressed("ui_down")
	else:
		left = Input.is_action_pressed("ui_left")
		right = Input.is_action_pressed("ui_right")
		up = Input.is_action_pressed("ui_up")
		down = Input.is_action_pressed("ui_down")
		
	if right:
		move_and_slide(Vector2(speed,0)*60)
	if left:
		move_and_slide(Vector2(-speed,0)*60)
	if down:
		move_and_slide(Vector2(0,speed)*60)
	if up and onG:
		yvel = -20#move_and_slide(Vector2(0,-speed)/delta)
		onG = false
	if swim:
		yvel = clamp(yvel,-3,3)
		onG = true
		oxy -= delta
	else: oxy = 10
	move_and_slide(Vector2(0,yvel)*60)
	
	get_parent().get_node("hud").get_node("oxytext").text = str(int(max(oxy,0)))
	
	if !onG or swim:
		yvel += 60*delta
	else:
		yvel = 0
				
	if Input.is_action_just_pressed("R"):
		position = spawnpoint
		
	if Input.is_action_just_pressed("minetoggle"):
		breaking = !breaking
	
	if health <= 0:
		position = spawnpoint
		health = 20
	
	get_parent().get_node("breaking").texture = breaktxts[floor(breakprg/breakspd)]
	get_parent().get_node("breaking").position = breakpos + Vector2(16,16)
		
	var cx = floor((position.x / 32) / chunkW)
	var cy = floor((position.y / 32) / chunkH)
	var ocx = floor((oldpos.x / 32) / chunkW)
	var ocy = floor((oldpos.y / 32) / chunkH)
	var changex = cx-ocx
	var changey = cy-ocy
	#print(cx, " ", ocx, " ", changex)
	if changex != 0 or changey != 0:
		emit_signal("changechunk",changex,changey)
	if immunity > 0:
		immunity -= delta
	else:
		immunity = 0
		if attacked or oxy < 0 or get_parent().get_node("TileMap").get_cellv(position/32) == 24 or get_parent().get_node("TileMap").get_cellv(position/32) == 14:
			immunity = 0.5
			health -= 1
	health = min(health,20-get_parent().difficulty*2)
	
	
	get_parent().get_node("hud/lifetext").text = str(health)


func _on_Area2D_area_entered(area):
	#print(area)
	if area.get_parent().get_parent() == get_parent().get_node("kollid"):
		attacked = true
	if area.get_parent().get_parent() == get_parent().get_node("kullad"):
		area.get_parent().queue_free()
		get_parent().get_node("hud").kuld += 1
	if area.get_parent() == get_parent().get_node("tulepallid"):
		attacked = true


func _on_Area2D_area_exited(area):
	attacked = false


func _on_Area2D2_body_entered(body):
	if body != self:
		onG = true
		health -= max(0,int(floor(yvel/32)))
	


func _on_Area2D2_body_exited(body):
	if body != self:
		onG = false
		
