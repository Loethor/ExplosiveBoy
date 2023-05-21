extends CharacterBody3D

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.15
const MOVEMENT_COOLDOWN = 0.15
const DIRECTIONS = {"right": Vector3.RIGHT,
					"left": Vector3.LEFT,
					"up": Vector3.FORWARD,
					"down": Vector3.BACK}

@onready var cooldown_timer = $CooldownTimer
@onready var grid := $"../Level/MapComponent/"
@onready var camera := $PlayerCamera

var bomb_scene := preload("res://scenes/characters/entities/bomb.tscn")
var can_act := true

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	print(position)
	print(global_position)
	camera.current = true


func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	for direction in DIRECTIONS.keys():
		if event.is_action_pressed(direction) and can_act:
			var target_position = global_position + DIRECTIONS[direction] * TILE_SIZE
			if (grid.is_position_free(target_position)):
				start_cooldown()
				var tween := create_tween()
				tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)

	if event.is_action_pressed("bomb") and can_act:
		place_bomb.rpc()

@rpc("call_local")
func place_bomb():
	var bomb := bomb_scene.instantiate()
	# the bomb is created at player's position
	bomb.position = position
	bomb.position.y = 0
	get_parent().add_child(bomb)

func start_cooldown():
	can_act = false
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func die():
	Signals.emit_signal("player_has_died")
	queue_free()

func _on_cooldown_timeout() -> void:
	can_act = true

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		print("%s killed the player" % body.name)
#		die()
