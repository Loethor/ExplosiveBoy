extends CharacterBody3D
class_name Player

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.25
const MOVEMENT_COOLDOWN = 0.25
const DIRECTIONS = {"right": Vector3.RIGHT,
					"left": Vector3.LEFT,
					"up": Vector3.FORWARD,
					"down": Vector3.BACK}

@onready var cooldown_timer = $CooldownTimer
@onready var grid = $"/root/world/Level/MapComponent"
@onready var camera := $PlayerCamera
@onready var ray := $RayCast3D

@export var bomb_scene : PackedScene
var can_act := true


func _enter_tree() -> void:
	position = $"/root/world/Level".obtain_spawn()
	print(position)

func _ready():
	$PlayerCamera.make_current()

func _input(event: InputEvent) -> void:
	if not can_act:
		return
	# Handle bomb.
	if Input.is_action_pressed("bomb"):
		$bomb_placed_sound.play()
		start_cooldown()
		place_bomb()

	var target_position = Vector3.INF
	var target_direction = Vector3.INF

	if Input.is_action_pressed("right"):
		target_direction = DIRECTIONS["right"]
	if Input.is_action_pressed("left"):
		target_direction = DIRECTIONS["left"]
	if Input.is_action_pressed("up"):
		target_direction = DIRECTIONS["up"]
	if Input.is_action_pressed("down"):
		target_direction = DIRECTIONS["down"]

	target_position = position + target_direction * TILE_SIZE

	if target_position != Vector3.INF:
		ray.target_position =  target_direction * TILE_SIZE
		ray.force_raycast_update()
		if (grid.is_position_free(target_position) and !ray.is_colliding()):
			start_cooldown()
			var tween := create_tween()
			tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)


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
		die()


func place_bomb():
	var bomb := bomb_scene.instantiate()
	# the bomb is created at player's position
	bomb.position = position
	bomb.position.y = 0
	get_parent().add_child(bomb)

