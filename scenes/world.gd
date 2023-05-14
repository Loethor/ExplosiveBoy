extends Node

signal has_exploded(position:Vector2)

@onready var world = $"."
var level_instance : Node3D = null



func unload_level():
	if(is_instance_valid(level_instance)):
		level_instance.queue_free()
	level_instance = null

func load_level(level_name:String) -> void:
	unload_level()
	var level_path := "res://scenes/levels/%s.tscn" % level_name
	var level_resouce := load(level_path)
	if (level_resouce):
		level_instance = level_resouce.instantiate()
		world.add_child(level_instance)

