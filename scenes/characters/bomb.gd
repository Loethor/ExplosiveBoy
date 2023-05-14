extends Node3D

@onready var collision := $StaticBody3D/CollisionShape3D
const TILE_SIZE = 1

@onready var bomb_area_of_efect = [
					Vector2(global_position.x + TILE_SIZE, global_position.z),
					Vector2(global_position.x - TILE_SIZE, global_position.z),
					Vector2(global_position.x, global_position.z + TILE_SIZE),
					Vector2(global_position.x, global_position.z - TILE_SIZE),
				]

func _ready() -> void:
	collision.disabled = true

func explode() -> void:
	print("BOOM")
	for area in bomb_area_of_efect:
		Signals.emit_signal("has_exploded", area)
	queue_free()

func _on_timer_timeout() -> void:
	explode()
