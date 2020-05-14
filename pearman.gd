extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit
signal unhit
var hxy
var killable
var health = 4

var yvel = 0
var onground
var timer = 0

export var speed = 2.5

var tulepall = preload("tulepall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var paused = get_parent().get_parent().paused
	if paused:
		return
	timer += delta
	hxy = get_parent().get_parent().get_node("hullmyts").position + Vector2(16,16)
	var vel =  hxy-position
	#vel.y = yvel
	vel.x = sign(vel.x)
	vel = vel*speed
	vel.y = yvel
	move_and_slide(vel*60)
	if timer >= 2:
		timer = 0
		var pew = tulepall.instance()
		get_parent().get_parent().get_node("tulepallid").add_child(pew)
		pew.position = position
		pew.vel = (hxy-position).normalized() * 6
		pew.scale = Vector2(2,2)
		
	#move_and_slide(Vector2(0,yvel)/delta)
	for i in get_slide_count():
		var c = get_slide_collision(i)
		#print(c.normal)
		if onground and c.normal.x != 0:
			#print(c.normal)
			yvel = -10
			#onground = false
		elif onground:
			yvel = 0
	if not onground:
		yvel += 60*delta
	if health <= 0:
		get_parent().get_parent().get_node("hud").collect(8)
		queue_free()
	if (position-hxy).x + (position-hxy).y > 1280:
		queue_free()
		
func _physics_process(delta):
	if get_parent().get_parent().paused: return
	var parent = get_parent().get_parent()
	var mxy = parent.get_global_mouse_position()/32
	var hxy = parent.get_node("hullmyts").position
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(hxy+Vector2(16,16), mxy*32-(mxy*32-hxy).normalized()*30, [parent.get_node("hullmyts")])
	if Input.is_action_just_pressed("LCLICK") and killable and !result:
		health -= 1
		yvel = -5
		if get_parent().get_parent().get_node("hud").inventory[get_parent().get_parent().get_node("hud").select] == 29:
			health -= 3

func _on_Area2D_mouse_entered():
	killable = true

func _on_Area2D_mouse_exited():
	killable = false


func _on_groundboxx_body_entered(body):
	if body != self:
		onground = true
		#print(body)


func _on_groundboxx_body_exited(body):
	if body != self:
		onground = false
		#print('rf ',body)




func _on_Area2D_area_entered(area):
	if area.get_parent() == get_parent().get_parent().get_node("explosions"):
		health -= 5
