extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var sl = 7

#255:nothimg, 0:air, 1:water, 2:grass, 3:sand, 4:stone, 5:log, 6:leaves
#7:coal bush, 8:pear, 9:water buffer, 10:tree seed, 11:unused, 12:aluminium
#13:bauxite, 14:lava, 15:lava buffer, 16:wood, 17:gold, 18:monster ruins,
#19:box, 20:algae, 21:onion, 22:onion seed, 23:pearman sculpture
#24:fire, 25:clay, 26:fired clay, 27:glass, 28:pickaxe, 29:sword, 30:lamp

var opaque = [2,3,4,5,12,13,14,15,16,17,18,19,23,20,25,26,32,33]

var semiopaque = [1,2,3,4,5,6,9,12,13,14,15,16,17,18,19,20,23,25,26,32,33]

var lighting = [14,15,24]
#var slighting = [30]

func is_skylit(x,y):
	if get_parent().get_cell(x,y) in lighting:
		return true
	else:
		var j = y
		while j > y-20:
			j -= 1
			if get_parent().get_cell(x,j) == 31:
				return true
			if semiopaque.has(get_parent().get_cell(x,j)):
				#print(get_parent().get_cell(x,j))
				return false
		return true

func is_blocklit(x,y):
	if get_parent().get_cell(x,y) in lighting:
		return true
	else: return false



func update_tile(x,y):
	var s = get_cell(x,y)
	var mo = max(max(get_cell(x,y-1),get_cell(x+1,y)),max(get_cell(x,y+1),get_cell(x-1,y)))-1
	set_cell(x,y,mo)
	s = mo
	
	if get_parent().get_cell(x,y) in opaque:
		s-=1
		set_cell(x,y,s)
	
	if is_skylit(x,y) and s < sl:
		s = sl
		set_cell(x,y,sl)
	if is_blocklit(x,y):
		s = 7
		set_cell(x,y,7)
	if get_parent().get_cell(x,y) == 30:
		set_cell(x,y,20)
	if get_cell(x,y) <= -1:
		set_cell(x,y,0)
		s = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	fix_invalid_tiles()
	#update_tile(0,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
