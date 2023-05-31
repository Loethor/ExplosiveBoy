class_name Bomb
extends Node3D

const TILE_SIZE = 1

@onready var bomb_area_of_efect = []
@onready var explosion_sound: AudioStreamPlayer3D = $explosion_sound
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var timer_label:Label3D = $time_label

var is_exploding = false

func _prepare_area_of_effect() -> void:
	bomb_area_of_efect.append(Vector2(global_position.x, global_position.z))
	for i in range(1, PlayerState.bomb_power + 1):
		bomb_area_of_efect.append(Vector2(global_position.x + TILE_SIZE * i, global_position.z ))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z + TILE_SIZE * i))
		bomb_area_of_efect.append(Vector2(global_position.x - TILE_SIZE * i, global_position.z))
		bomb_area_of_efect.append(Vector2(global_position.x, global_position.z - TILE_SIZE * i))

func _ready() -> void:
	_update_time_label()
	_prepare_area_of_effect()
	anim.play("bombAction")
	await get_tree().create_timer(1)

func _process(delta: float) -> void:
	_update_time_label()

func explode() -> void:
	if not is_exploding:
		timer_label.hide()
		is_exploding = true
		_supress_particles()
		for targeted_area in bomb_area_of_efect:
			if Signals.emit_signal("has_exploded", targeted_area):
				printerr("Error on signal: has_exploded")
		explosion_sound.play()
		_hide_mesh()

		await explosion_sound.finished
		queue_free()

func _on_timer_timeout() -> void:
	explode()

func _hide_mesh() -> void:
	var bomb_mesh:MeshInstance3D = $bomb
	var rope_mesh:MeshInstance3D = $rope

	bomb_mesh.hide()
	rope_mesh.hide()

func _supress_particles() -> void:
	var fire_particles: GPUParticles3D = $FireParticles
	fire_particles.emitting = false
	fire_particles.hide()

func _update_time_label():
	timer_label.text = str(ceil($Timer.time_left))
