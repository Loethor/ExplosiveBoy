extends GridMap

var coordinate = FastNoiseLite.new()

var width = 40
var height = 40
@onready var player = $"../TestPlayer"
@export var seed :int

@export_range(1, 10, .2) var noise_scale: float = 1
@export_range(0.3, 0.4, 0.01) var crumble_limit: float = 0.3
@export_range(0.6, 0.8, 0.01) var block_limit: float = 0.6

func _ready() -> void:
#	coordinate.seed = randi()
	coordinate.seed = seed
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
			var coord = (coordinate.get_noise_2d(cell_pos.x * noise_scale, cell_pos.z * noise_scale) + 1)/2
#			print(coord)
#			print(floor(coor.d))
			if coord >= 0 and coord < crumble_limit:
				set_cell_item(cell_pos, 1)
			elif coord >= crumble_limit and coord < block_limit:
				set_cell_item(cell_pos, 0)
			else:
				set_cell_item(cell_pos, 2)

