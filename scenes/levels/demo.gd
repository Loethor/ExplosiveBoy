extends Node3D
class_name DemoLevel

var spawn_locations:Array[Vector3] = []

func _ready() -> void:
	for spawn in $Spawns.get_children() as Array[Marker3D]:
		spawn_locations.append(spawn.position)
	randomize()

func obtain_spawn() -> Vector3:
	var index = randi() % spawn_locations.size()
	return spawn_locations.pop_at(index)
