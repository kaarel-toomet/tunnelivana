extends Node2D


# Declare member variables here. Examples:
# var a = 2
signal pause
export var paused = false
var sf = 1

var difficulty = -1

export (PackedScene) var koll
var pearman = preload("res://pearman.tscn")
var cat = preload("res://kass.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("P"):
		emit_signal("pause")
		paused = !paused
	if randi() % 800*60*delta*(1-difficulty*0.4) <= sf and not paused:
		var spawn = koll.instance()
		$kollid.add_child(spawn)
		var sxmax = $hullmyts.position.x+(1.5*$TileMap.chunkW*32)
		var sxmin = $hullmyts.position.x-(1.5*$TileMap.chunkW*32)
		var sx = (randi() % int((sxmax-sxmin)) + sxmin)
		var symax = $hullmyts.position.y+(1.5*$TileMap.chunkH*32)
		var symin = $hullmyts.position.y-(1.5*$TileMap.chunkH*32)
		var sy = (randi() % int((symax-symin)) + symin)
		sx = (randi() % int((sxmax-sxmin)) + sxmin)
		sy = (randi() % int((symax-symin)) + symin)
		if $TileMap.get_cell(sx/32,sy/32) in $TileMap.solid:
			spawn.queue_free()
		spawn.position = Vector2(sx,sy)
		spawn.scale = Vector2(2,2)
	if randi() % 800*60*delta*(1-difficulty*0.4) <= sf and not paused:
		var spawn = pearman.instance()
		$pirnivanad.add_child(spawn)
		var sxmax = $hullmyts.position.x+(1.5*$TileMap.chunkW*32)
		var sxmin = $hullmyts.position.x-(1.5*$TileMap.chunkW*32)
		var sx = (randi() % int((sxmax-sxmin)) + sxmin)
		var symax = $hullmyts.position.y+(1.5*$TileMap.chunkH*32)
		var symin = $hullmyts.position.y-(1.5*$TileMap.chunkH*32)
		var sy = (randi() % int((symax-symin)) + symin)
		sx = (randi() % int((sxmax-sxmin)) + sxmin)
		sy = (randi() % int((symax-symin)) + symin)
		if $TileMap.get_cell(sx/32,sy/32) in $TileMap.solid:
			spawn.queue_free()
		spawn.position = Vector2(sx,sy)
		spawn.scale = Vector2(2,2)
	if randi() % 800*60*delta == 0 and not paused:
		var spawn = cat.instance()
		$kassid.add_child(spawn)
		var sxmax = $hullmyts.position.x+(1.5*$TileMap.chunkW*32)
		var sxmin = $hullmyts.position.x-(1.5*$TileMap.chunkW*32)
		var sx = (randi() % int((sxmax-sxmin)) + sxmin)
		var symax = $hullmyts.position.y+(1.5*$TileMap.chunkH*32)
		var symin = $hullmyts.position.y-(1.5*$TileMap.chunkH*32)
		var sy = (randi() % int((symax-symin)) + symin)
		sx = (randi() % int((sxmax-sxmin)) + sxmin)
		sy = (randi() % int((symax-symin)) + symin)
		if $TileMap.get_cell(sx/32,sy/32) in $TileMap.solid:
			spawn.queue_free()
		spawn.position = Vector2(sx,sy)
		spawn.scale = Vector2(2,2)
	#print(sf)
