extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit
signal unhit
var hxy
var killable
export var speed = 3.5


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
	vel = vel.normalized()*speed
	move_and_slide(vel/delta)
	if Input.is_action_just_pressed("LCLICK") and killable:
		get_parent().get_parent().get_node("hud").kolliv += 1
		queue_free()

func _on_Area2D_mouse_entered():
	killable = true

func _on_Area2D_mouse_exited():
	killable = false
