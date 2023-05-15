extends CharacterBody3D

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.25
const MOVEMENT_COOLDOWN = 1
const DIRECTIONS = [Vector3.RIGHT,
					Vector3.LEFT,
					Vector3.FORWARD,
					Vector3.BACK]

@onready var ray := $RayCast3D
@onready var cooldown_timer = $CooldownTimer

var can_act := true

func _ready() -> void:
	randomize()
	move()

func move():
	# move the raycast to the new position
	var rand_index := randi() % DIRECTIONS.size()
	var target_direction = DIRECTIONS[rand_index] * TILE_SIZE
	ray.target_position = target_direction
	ray.force_raycast_update()
	if !ray.is_colliding():
		start_cooldown()
		var new_position = position + target_direction
		var tween := create_tween()
		tween.tween_property(self, "position", new_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)

func start_cooldown():
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func _on_cooldown_timer_timeout() -> void:
	move()
