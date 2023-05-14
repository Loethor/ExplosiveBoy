extends Node

class_name MapComponent

@onready var grid_map := $GridMap
var explosion_resource := preload("res://scenes/characters/explosion.tscn")

var grid_types = {
	"floor": 0,
	"brittle_block": 1,
	"block": 2,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.has_exploded.connect(_explosion_on_area.bind())

func _explosion_on_area(target_area:Vector2):

	# convert target area (2D vector) into grid position (3D vector)
	var target_grid_position = Vector3i(target_area.x, 0, target_area.y)
	var grid_id = grid_map.get_cell_item(target_grid_position)

	# destroy brittle block
	if grid_id == grid_types["brittle_block"]:
		grid_map.set_cell_item(target_grid_position, 0)

	# create explosions
	var explosion = explosion_resource.instantiate()
	# explosion needs to be raised 1 in y coordinate
	explosion.position = target_grid_position + Vector3i(0,1,0)
	add_child(explosion)
