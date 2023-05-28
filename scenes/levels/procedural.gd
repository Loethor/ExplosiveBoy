extends GridMap

var coordinate = FastNoiseLite.new()

var width = 40
var height = 40
@onready var player = $"../TestPlayer"

func _ready() -> void:
	coordinate.seed = randi()
#	for i in range(-width,width):
#		for j in range(-height, height):
#			var cell_pos = Vector3i(i, 0, j)
#			var coord = (coordinate.get_noise_2d(cell_pos.x, cell_pos.z) + 1)/2*3
#			print(coord)
#			print(floor(coord))
#			set_cell_item(cell_pos, floor(coord))


func _process(delta: float) -> void:
	generate_chunk(player.position)

func generate_chunk(pos):
	var tile_pos = local_to_map(pos)
	for i in range(-width,width):
		for j in range(-height, height):
			var cell_pos = Vector3i(tile_pos.x + i, 0, tile_pos.z + j)
			var coord = (coordinate.get_noise_2d(cell_pos.x, cell_pos.z) + 1)/2
#			print(coord)
#			print(floor(coor.d))
			if coord >= 0 and coord < 0.3:
				set_cell_item(cell_pos, 1)
			elif coord >= 0.4 and coord < 0.6:
				set_cell_item(cell_pos, 0)
			else:
				set_cell_item(cell_pos, 2)

