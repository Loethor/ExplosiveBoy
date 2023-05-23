extends Node

@export var PlayerScene = preload("res://characters/player.tscn")

@onready var level = $Level

# This should really be configured on the TestMap (and other maps!)
# That way individual maps could specify where mobs move to/from
# This script could then get those by querying a Map scripts mob_targets property.
# For now, I'm being lazy :)

func _ready():
	if NetworkState.is_server:
		# Listen to peer connections, and create new character for them
		multiplayer.peer_connected.connect(self.create_player)
		# Listen to peer disconnections, and destroy their players
		multiplayer.peer_disconnected.connect(self.destroy_player)

		create_player(multiplayer.get_unique_id())

func create_player(id : int) -> void:
	# Instantiate a new player for this client.
	var p = PlayerScene.instantiate()
	# TODO instantiate vs new?

	# Set the name, so players can figure out their local authority
	p.name = str(id)
#	p.Networking.sync_position = level.obtain_spawn()

	$Players.add_child(p)

func destroy_player(id : int) -> void:
	# Delete this peer's node.
	$Players.get_node(str(id)).queue_free()
