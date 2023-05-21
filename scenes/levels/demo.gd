extends Node3D

@onready var sp1 = $Spawn1
@onready var sp2 = $Spawn2
@onready var sp3 = $Spawn3
@onready var sp4 = $Spawn4

var spawn_locations:Array[Vector3] = []

func _ready() -> void:
	spawn_locations.append(sp1.position)
	spawn_locations.append(sp2.position)
	spawn_locations.append(sp3.position)
	spawn_locations.append(sp4.position)
	randomize()


func obtain_spawn() -> Vector3:
	var index = randi() % spawn_locations.size()
	return spawn_locations.pop_at(index)
