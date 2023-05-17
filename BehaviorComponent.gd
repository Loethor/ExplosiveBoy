extends Node
class_name BehaviorComponent

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.25
const MOVEMENT_COOLDOWN = 1
const DIRECTIONS = [Vector3.RIGHT,
					Vector3.LEFT,
					Vector3.FORWARD,
					Vector3.BACK]

@onready var cooldown_timer = $CooldownTimer
@onready var grid := $"../../MapComponent/"

var can_act := true
var can_move

enum BehaviorsEnum {random, passive, aggresive}
@export var BehaviorType: BehaviorsEnum = BehaviorsEnum.passive

func _ready() -> void:
	randomize()

func move():
	match BehaviorType:
		BehaviorsEnum.passive:
			pass
		BehaviorsEnum.random:
			move_randomly()
		BehaviorsEnum.aggresive:
			pass
		_:
			pass

func move_randomly():
	can_move = false
	var target_position
	while(!can_move):
		var rand_index := randi() % DIRECTIONS.size()
		var target_direction = DIRECTIONS[rand_index] * TILE_SIZE
		target_position = get_parent().global_position + target_direction
		can_move = grid.is_position_free(target_position)
	start_cooldown()
	var tween := create_tween()
	tween.tween_property(get_parent(), "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)

func start_cooldown():
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func _on_cooldown_timer_timeout() -> void:
	move()
