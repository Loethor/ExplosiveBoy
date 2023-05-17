extends CharacterBody3D

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.25
const MOVEMENT_COOLDOWN = 1
const DIRECTIONS = [Vector3.RIGHT,
					Vector3.LEFT,
					Vector3.FORWARD,
					Vector3.BACK]

@onready var cooldown_timer = $CooldownTimer
@onready var grid := $"../MapComponent/"

var can_act := true
var can_move

func _ready() -> void:
	randomize()
	move()

func move():
	can_move = false
	var target_position
	while(!can_move):
		var rand_index := randi() % DIRECTIONS.size()
		var target_direction = DIRECTIONS[rand_index] * TILE_SIZE
		target_position = global_position + target_direction
		can_move = grid.is_position_free(target_position)
	start_cooldown()
	var tween := create_tween()
	tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)

func start_cooldown():
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func _on_cooldown_timer_timeout() -> void:
	move()

func die():
	queue_free()
