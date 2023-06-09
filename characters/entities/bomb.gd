extends Node3D

const TILE_SIZE = 1

@onready var collision := $CollisionShape3D
@onready var bomb_area_of_efect = []
@onready var explosion_sound = $explosion_sound

var bomb_power = 1
var is_exploding = false

func _prepare_area_of_effect(bomb_power):
	bomb_area_of_efect.append(Vector2(global_position.x, global_position.z))
	for i in range(1, bomb_power + 1):
		bomb_area_of_efect.append(Vector2(global_position.x + TILE_SIZE * i, global_position.z ))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z + TILE_SIZE * i))
		bomb_area_of_efect.append(Vector2(global_position.x - TILE_SIZE * i, global_position.z))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z - TILE_SIZE * i))

func _ready() -> void:
	_prepare_area_of_effect(bomb_power)

func explode() -> void:
	print("BOOM")
	if not is_exploding:
		is_exploding = true
		for targeted_area in bomb_area_of_efect:
			Signals.emit_signal("has_exploded", targeted_area)
		explosion_sound.play()
		$bomb.hide()
		$rope.hide()
		await explosion_sound.finished
		queue_free()

func _on_timer_timeout() -> void:
	explode()

