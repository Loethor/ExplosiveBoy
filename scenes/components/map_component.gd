extends Node

class_name MapComponent

@onready var grid_map := $GridMap
var explosion_resource := preload("res://scenes/characters/explosion.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.has_exploded.connect(_explosion_on_area.bind())

func _explosion_on_area(area:Vector2):
	print("Exploded on %s" % area)
	print(Vector3i(area.x, 0, area.y))
	var target_position = Vector3i(area.x, 0, area.y)
	var grid_id = grid_map.get_cell_item(target_position)
	if grid_id == 1:
		grid_map.set_cell_item(target_position, 0)
	var explosion = explosion_resource.instantiate()
	explosion.position = target_position
	add_child(explosion)

	print(grid_id)
