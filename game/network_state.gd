extends Node

var is_server := false

func start_network(server: bool, ip: String = '', port: int = 4242) -> void:
	is_server = server
	var peer = ENetMultiplayerPeer.new()
	if server:
		peer.create_server(port)
		print('server listening on localhost %s' % port)
		upnp_setup(port)
	else:
		show_message("Connecting...")
		peer.create_client(ip, port)
		multiplayer.connection_failed.connect(_on_connection_failed)
		multiplayer.connected_to_server.connect(_on_connection_success)

	multiplayer.set_multiplayer_peer(peer)

func show_message(message : String) -> void:
	$CanvasLayer/CenterContainer/Panel/Label.text = message
	$CanvasLayer/CenterContainer.visible = true

func hide_message() -> void:
	$CanvasLayer/CenterContainer.visible = false

func _on_connection_failed():
	show_message("Failed to connect :(")
	await get_tree().create_timer(2).timeout
	hide_message()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_connection_success():
	show_message("Connected!")
	await get_tree().create_timer(1).timeout
	hide_message()

# how to connect with other people
func upnp_setup(port):
	var upnp = UPNP.new()

	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	var map_result = upnp.add_port_mapping(port)
	assert(map_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Port Mapping Failed! Error %s" % map_result)

	print("Success! Join Address: %s" % upnp.query_external_address())
