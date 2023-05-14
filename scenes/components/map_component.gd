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

func _explosion_on_area(area:Vector2):
	print("Exploded on %s" % area)
	print(Vector3i(area.x, 0, area.y))
	var target_position = Vector3i(area.x, 0, area.y)
	var grid_id = grid_map.get_cell_item(target_position)
	if grid_id == grid_types["brittle_block"]:
		grid_map.set_cell_item(target_position, 0)
	var explosion = explosion_resource.instantiate()
	explosion.position = target_position + Vector3i(0,1,0)
	add_child(explosion)

	print(grid_id)
