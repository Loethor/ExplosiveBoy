extends GridMap

var coordinate = FastNoiseLite.new()

var width = 20
var height = 14

@onready var player = $"../TestPlayer"
@export var seed :int

@export_range(1, 10, .2) var noise_scale_x: float = 1
@export_range(1, 10, .2) var noise_scale_y: float = 1
@export_range(0.3, 0.4, 0.01) var crumble_limit: float = 0.3
@export_range(0.6, 0.8, 0.01) var block_limit: float = 0.6

var visited_positions:Dictionary

func _ready() -> void:
#	coordinate.seed = randi()
	coordinate.seed = seed
	generate_chunk(player.position)


func _process(delta: float) -> void:
	generate_chunk(player.position)

func generate_chunk(pos):
	coordinate.seed = seed
	var tile_pos = local_to_map(pos)
	for i in range(-width,width):
		for j in range(-height, height):
			var coord_position = Vector2i(tile_pos.x + i, tile_pos.z + j)
			if coord_position not in visited_positions:
				var cell_pos = Vector3i(tile_pos.x + i, 0, tile_pos.z + j)
				var coord = (coordinate.get_noise_2d(cell_pos.x * noise_scale_x, cell_pos.z * noise_scale_y) + 1)/2

				if 0 <= coord and coord < crumble_limit:
					set_cell_item(cell_pos, 1)
				elif crumble_limit <= coord and coord < block_limit:
					set_cell_item(cell_pos, 0)
				else:
					set_cell_item(cell_pos, 2)
				visited_positions[coord_position] = 0

