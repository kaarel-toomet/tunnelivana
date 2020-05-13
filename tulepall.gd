extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2()
var life = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().paused: return
	position += vel*delta*60
	life -= delta
	if life <= 0:
		queue_free()


func _on_tulepall_body_entered(body):
	if body == get_parent().get_parent().get_node("TileMap"):
		queue_free()


