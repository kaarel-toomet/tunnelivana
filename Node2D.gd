extends Node2D


# Declare member variables here. Examples:
# var a = 2
var amounts


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	#var amounts = get_parent().amounts
	#var label = Label.new()
	#var font = label.get_font("")
	#for s in range(20):
	#draw_string(font, Vector2(20+s*36,50), str(amounts[s]))
	#label.free()




func _draw():
	amounts = get_parent().amounts
	var label = Label.new()
	var font = label.get_font("")
	for s in range(20):
		draw_string(font, Vector2(20+s*36,50), str(amounts[s]))
	label.free()
	#print(amounts)

#func _notification(what):
	#if what == NOTIFICATION_DRAW:
	#	var amounts = get_parent().amounts
	#	var label = Label.new()
	#	var font = label.get_font("")
	#	for s in range(20):
	#		draw_string(font, Vector2(20+s*36,50), str(amounts[s]))
	#	label.free()
	#	print("drdrfre")
