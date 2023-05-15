extends CharacterBody3D

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.15
const MOVEMENT_COOLDOWN = 0.15
const DIRECTIONS = {"right": Vector3.RIGHT,
				"left": Vector3.LEFT,
				"up": Vector3.FORWARD,
				"down": Vector3.BACK}

@onready var ray := $RayCast3D
@onready var cooldown_timer = $CooldownTimer

var bomb_scene := preload("res://scenes/characters/bomb.tscn")
var can_act := true

func _unhandled_input(event):
	for direction in DIRECTIONS.keys():
		if event.is_action_pressed(direction) and can_act:
			move(direction)

	if event.is_action_pressed("bomb") and can_act:
		place_bomb()

func move(direction):
	# move the raycast to the new position
	var target_direction = DIRECTIONS[direction] * TILE_SIZE
	ray.target_position = target_direction
	ray.force_raycast_update()
	if !ray.is_colliding():
		start_cooldown()
		var new_position = position + target_direction
		var tween := create_tween()
		tween.tween_property(self, "position", new_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)

func place_bomb():
	var bomb := bomb_scene.instantiate()
	# the bomb is created at player's position
	bomb.position = position
	bomb.position.y = 0
	print("Bomb placed at %s" % bomb.position)
	print("Bomb placed at %s" % bomb.global_position)
	get_parent().add_child(bomb)

func die():
	Signals.emit_signal("player_has_died")
	queue_free()

func start_cooldown():
	can_act = false
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func _on_cooldown_timeout() -> void:
	can_act = true

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("explosions") or body.is_in_group("enemies"):
		print("%s killed the player" % body.name)
		die()
