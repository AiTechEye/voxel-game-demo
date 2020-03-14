extends Spatial

var noise = OpenSimplexNoise.new()
var rnd = RandomNumberGenerator.new()
var nodes = {}
var player_pos = Vector3()
var block_instance = load("res://block.tscn")

var player
var time = 0
var map
var map_x = 1000
var map_z = 1000
var map_y = 10
var rad = 10

func _ready():
	OS.window_position = Vector2(0,0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player = load("res://player.tscn").instance()
	add_child(player)
	player.transform.origin.y = map_y+1
	
	map = get_node("map")

	noise.seed = rnd.randi()
#	noise.octaves = 1
#	noise.period = 40
#	noise.persistence = 2
func _process(delta):
	player_pos = player.transform.origin
	time += delta
	if time > 0.01:
		time = 0
		for x in range(player_pos.x-rad,player_pos.x+rad):
			for y in range(player_pos.y-rad,player_pos.y+rad):
				for z in range(player_pos.z-rad,player_pos.z+rad):
					var a = noise.get_noise_3d(x,y,z) * 10
					if a >= 0.1 and a <= 3:
						var v = Vector3(x,y,z)
						if nodes.get(v) == null:
							if (x > -map_x and x < map_x) and (z > -map_z and z < map_z) and (y > 0 and y < map_y):
								add_node(v)
					var V = Vector3(x,0,z)
					if nodes.get(V) == null:
						add_node(V)

func add_node(pos):
	if nodes.get(pos) == null:
		#var b = block_instance.instance()
		#b.transform.origin = pos
		#add_child(b)
		nodes[pos] = true#b
		map.set_cell_item(pos.x,pos.y,pos.z,0)
func remove_node(pos):
	map.set_cell_item(pos.x,pos.y,pos.z,-1)
#	if nodes.get(pos):
#		nodes[pos].queue_free()
#		map.set_cell_item(pos.x,pos.y,pos.z,-1)
#		nodes.erase(pos)
