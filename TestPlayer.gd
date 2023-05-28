extends CharacterBody3D
class_name TestPlayer

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.05

const DIRECTIONS = {"right": Vector3.RIGHT,
					"left": Vector3.LEFT,
					"up": Vector3.FORWARD,
					"down": Vector3.BACK}


@onready var camera := $PlayerCamera

var can_move = true

func _input(event: InputEvent) -> void:
	if not can_move:
		return

	var target_position = Vector3.INF
	var target_direction = Vector3.INF

	if event.is_action_pressed("right"):
		target_direction = DIRECTIONS["right"]
	if event.is_action_pressed("left"):
		target_direction = DIRECTIONS["left"]
	if event.is_action_pressed("up"):
		target_direction = DIRECTIONS["up"]
	if event.is_action_pressed("down"):
		target_direction = DIRECTIONS["down"]

	if target_direction != Vector3.INF:
		can_move = false
		target_position = position + target_direction * TILE_SIZE
		var tween := create_tween()
		tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)
		await get_tree().create_timer(MOVEMENT_DURATION).timeout
		can_move = true
