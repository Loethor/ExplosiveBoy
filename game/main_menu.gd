extends Control

@export var map_scene : PackedScene
@export var ip_input : LineEdit
@export var port_input : LineEdit


func _on_single_player_button_pressed() -> void:
	load_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func load_scene():
	get_tree().change_scene_to_packed(map_scene)
