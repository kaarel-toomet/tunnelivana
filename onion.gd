extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector2()
var life = 20
var boom = preload("res://boom.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_parent().paused: return
	position += vel*delta*60
	vel.y += 0.1
	life -= delta
	if life <= 0:
		queue_free()


func _on_tulepall_body_entered(body):
	if body == get_parent().get_parent().get_node("TileMap"):
		var tilemap = get_parent().get_parent().get_node("TileMap")
		var pos = position/32
		for x in range(pos.x-5,pos.x+5):
			for y in range(pos.y-5,pos.y+5):
				var dist = abs(x-pos.x) + abs(y-pos.y)
				if dist < rand_range(2.5,5):
					tilemap.tarbreak(x,y)
					if rand_range(0,1) < 0.1:
						tilemap.set_cell(x,y,24)
		var bam = boom.instance()
		get_parent().get_parent().get_node("explosions").add_child(bam)
		bam.position = position
		#bam.scale = Vector2(2,2)
		queue_free()


