extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit
signal unhit
var hxy
var killable

var yvel = 0
var onground

export var speed = 2.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var paused = get_parent().get_parent().paused
	if paused:
		return
	hxy = get_parent().get_parent().get_node("hullmyts").position
	var vel =  hxy-position
	vel.y = 0
	vel.x = sign(vel.x)
	vel = vel*speed
	move_and_slide(vel/delta)
	move_and_slide(Vector2(0,yvel)/delta)
	if not onground:
		yvel += 1
	else:
		yvel = -12
		onground = false
	if Input.is_action_just_pressed("LCLICK") and killable:
		get_parent().get_parent().get_node("hud").kolliv += 1
		queue_free()

func _on_Area2D_mouse_entered():
	killable = true

func _on_Area2D_mouse_exited():
	killable = false


func _on_groundboxx_body_entered(body):
	onground = true


func _on_groundboxx_body_exited(body):
	onground = false
