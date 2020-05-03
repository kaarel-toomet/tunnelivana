extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size  # Size of the game window.
var speed = 32
var pause = false
export (PackedScene) var kuld

var chunkW = 15 # change these with the chunk sizes in tilemap.gd
var chunkH = 10

var immunity = 0
var attacked = false

export var health = 20

var oldpos = position
var velocity = Vector2()
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
	fast = !!!!!!!!!!!!!!!!!!!Input.is_action_pressed("LSHIFT")
	if fast:
		velocity.x = 0
		velocity.y = 0
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_released("ui_left") and !fast:
		velocity.x += 1
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_released("ui_right") and !fast:
		velocity.x += -1
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_up") and !fast:
		velocity.y += 1
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_down") and !fast:
		velocity.y += -1
	if Input.is_action_just_pressed("R"):
		position.x = 0
		position.y = 0
	if velocity.length() > 0:
		position += velocity*speed
	if get_parent().get_node("TileMap").get_cell(floor(position[0]/32),floor(position[1]/32)) != -1:
		get_parent().get_node("TileMap").emit_signal("lammutus",get_parent().get_node("TileMap").get_cell((position[0]/32),floor(position[1]/32)))

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
