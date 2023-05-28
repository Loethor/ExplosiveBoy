extends Node3D

var spawn_locations:Array[Vector3] = []

func _ready() -> void:
	for spawn in $Spawns.get_children():
		spawn_locations.append(spawn.position)
	randomize()

func obtain_spawn() -> Vector3:
	var index = randi() % spawn_locations.size()
	return spawn_locations.pop_at(index)
