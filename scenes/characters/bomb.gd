extends Node3D

const TILE_SIZE = 1
var bomb_power = 3

@onready var collision := $StaticBody3D/CollisionShape3D
@onready var bomb_area_of_efect = []
var is_exploding = false

func _prepare_area_of_effect(bomb_power):
	bomb_area_of_efect.append(Vector2(global_position.x, global_position.z))
	for i in range(1, bomb_power + 1):
		bomb_area_of_efect.append(Vector2(global_position.x + TILE_SIZE * i, global_position.z ))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z + TILE_SIZE * i))
		bomb_area_of_efect.append(Vector2(global_position.x - TILE_SIZE * i, global_position.z))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z - TILE_SIZE * i))

func _ready() -> void:
#	print("My name is %s "% name)
	Signals.connect("has_exploded", _check_chain_reaction)
	_prepare_area_of_effect(bomb_power)

func _check_chain_reaction(explosion_position: Vector2):
	var my_2d_position = Vector2(position.x, position.z)
	if (my_2d_position == explosion_position) and not is_exploding:
		explode()


func explode() -> void:
	print("BOOM")
	is_exploding = true
	for targeted_area in bomb_area_of_efect:
		Signals.emit_signal("has_exploded", targeted_area)
	queue_free()

func _on_timer_timeout() -> void:
	explode()
