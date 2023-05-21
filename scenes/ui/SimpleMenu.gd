extends Control

@onready var world = $"/root/world"
@onready var level = $"/root/world/Level"
@onready var ui = $"."
var enet_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const Player = preload("res://scenes/characters/player.tscn")



func _on_host_button_pressed() -> void:
	# Creates the server
	ui.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)

	print(multiplayer.get_unique_id())
	# Adds the player
	add_player(multiplayer.get_unique_id())

	# Universal Plug and Play setup
	upnp_setup()

func _on_join_button_pressed() -> void:
	# Creates the client
	ui.hide()
	enet_peer.create_client("localhost", PORT)
#	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	var spawn_location = level.obtain_spawn()
	print("Spawn location of player %s: %s" % [peer_id, spawn_location])
	player.global_position = spawn_location
	world.add_child(player)

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player: player.queue_free()

# how to connect with other people
func upnp_setup():
	var upnp = UPNP.new()

	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(PORT)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)

#	print("Success! Join Address: %s" % upnp.query_external_address())
