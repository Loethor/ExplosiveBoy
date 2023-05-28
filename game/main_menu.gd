extends Control

@export var map_scene : PackedScene
@export var ip_input : LineEdit
@export var port_input : LineEdit


func _on_single_player_button_pressed() -> void:
	load_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()


# multiplayer
func _ready():
	# Start the server if Godot is passed the "--server" argument.
	# This lets us host the server headless if we want :)
	if "--server" in OS.get_cmdline_args():
		_on_host_button_pressed.call_deferred()


func _on_host_button_pressed() -> void:
	NetworkState.start_network(true)
	load_scene()

func _on_join_button_pressed() -> void:
	NetworkState.start_network(false, ip_input.text, port_input.text.to_int())
	load_scene()

func load_scene():
	get_tree().change_scene_to_packed(map_scene)




#func add_player(peer_id):
#	var player = Player.instantiate()
#	player.name = str(peer_id)
#	var spawn_location = level.obtain_spawn()
#	print("Spawn location of player %s: %s" % [peer_id, spawn_location])
#	player.global_position = spawn_location
#	players.add_child(player)
#
#func remove_player(peer_id):
#	var player = get_node_or_null(str(peer_id))
#	if player: player.queue_free()



