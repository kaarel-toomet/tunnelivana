extends MenuButton


# Declare member variables here.
var popup
var difficulty = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_popup()
	popup.add_item("Easy")
	popup.add_item("Normal")
	popup.add_item("Hard")
	popup.add_item("Insane")
	popup.connect("id_pressed", self, "_on_item_pressed")

#func _process(delta):
#	pass
func _on_item_pressed(ID):
	#print(popup.get_item_text(ID), " pressed")
	text = popup.get_item_text(ID)
	if text == "Easy":
		difficulty = -2
	elif text == "Normal":
		difficulty = -1
	elif text == "Hard":
		difficulty = 0
	else:
		difficulty = 2
	get_parent().get_parent().get_parent().difficulty = difficulty
