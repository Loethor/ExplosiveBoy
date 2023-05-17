extends Node

class_name MapComponent

@onready var grid_map := $GridMap

var explosion_resource := preload("res://scenes/characters/entities/explosion.tscn")
var grid_types = {
	"floor": 0,
	"brittle_block": 1,
	"block": 2,
}
var target_grid_position: Vector3i
var grid_id: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.has_exploded.connect(_explosion_on_area.bind())

func is_position_free(target_position:Vector3)->bool:
	# convert target position (3D vector) into grid position (3Di vector)
	target_grid_position = Vector3i(target_position.x, 0, target_position.z)
	grid_id = grid_map.get_cell_item(target_grid_position)

	# only floor is allowed movement
	if grid_id == grid_types["floor"]:
		return true
	else:
		return false

func _explosion_on_area(target_area:Vector2):

	# convert target area (2D vector) into grid position (3D vector)
	target_grid_position = Vector3i(target_area.x, 0, target_area.y)
	grid_id = grid_map.get_cell_item(target_grid_position)

	# destroy brittle block
	if grid_id == grid_types["brittle_block"]:
		grid_map.set_cell_item(target_grid_position, 0)

	# create explosions
	var explosion = explosion_resource.instantiate()
	# explosion needs to be raised 1 in y coordinate
	explosion.position = target_grid_position + Vector3i(0,1,0)
	add_child(explosion)
