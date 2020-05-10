extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size  # Size of the game window.
var speed = 32
var pause = false
export (PackedScene) var kuld

var left = false
var right = false
var up = false
var down = false

var chunkW = 15 # change these with the chunk sizes in tilemap.gd
var chunkH = 10

var immunity = 0
var attacked = false

export var health = 20

var oldpos = position
var fast = false


signal changechunk


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 0#chunkW*48
	position.y = 0#chunkH*48


#Calledeveryframe.'delta'istheelapsedtimesincethepreviousframe.
func _process(delta):
	if pause:
		return
	var oldpos = position
	if Input.is_action_just_pressed("LSHIFT"):
		fast = true
	if Input.is_action_just_released("LSHIFT"):
		fast = false
	
	if get_parent().get_node("TileMap").get_cell(floor(position[0]/32),floor(position[1]/32)) in get_parent().get_node("TileMap").solid:
		get_parent().get_node("TileMap").emit_signal("lammutus",get_parent().get_node("TileMap").get_cell((position[0]/32),floor(position[1]/32)))
		fast = false
		
	if not fast:
		left = Input.is_action_just_pressed("ui_left")
		right = Input.is_action_just_pressed("ui_right")
		up = Input.is_action_just_pressed("ui_up")
		down = Input.is_action_just_pressed("ui_down")
	else:
		left = Input.is_action_pressed("ui_left")
		right = Input.is_action_pressed("ui_right")
		up = Input.is_action_pressed("ui_up")
		down = Input.is_action_pressed("ui_down")
		
	if right:
		position.x += speed
	if left:
		position.x += -speed
	if down:
		position.y += speed
	if up:
		position.y += -speed
		
	if Input.is_action_just_pressed("R"):
		position.x = 0
		position.y = 0
	
	if health == 0:
		position = Vector2(0,0)
		health = 20
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
		if attacked:
			immunity = 0.5
			health -= 1
	get_parent().get_node("hud/lifetext").text = str(health)


func _on_main_pause():
	if pause == true:
		pause = false
	else:
		pause = true


func _on_Area2D_area_entered(area):
	#print(area)
	if area.get_parent().get_parent() == get_parent().get_node("kollid"):
		attacked = true
	if area.get_parent().get_parent() == get_parent().get_node("kullad"):
		area.get_parent().queue_free()
		get_parent().get_node("hud").kuld += 1


func _on_Area2D_area_exited(area):
	attacked = false
