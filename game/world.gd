extends Node

@export var PlayerScene = preload("res://characters/player.tscn")
@onready var level = $Level

func _ready():
	create_player()

func create_player() -> void:
	var p = PlayerScene.instantiate()
	$Players.add_child(p)
