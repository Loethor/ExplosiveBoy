extends CharacterBody3D
class_name Player

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.25
const MOVEMENT_COOLDOWN = 0.25
const DIRECTIONS = {"right": Vector3.RIGHT,
					"left": Vector3.LEFT,
					"up": Vector3.FORWARD,
					"down": Vector3.BACK}

@onready var cooldown_timer:Timer = $CooldownTimer
@onready var map: MapComponent = $"/root/world/Level/MapComponent"
@onready var camera: Camera3D = $PlayerCamera
@onready var ray: RayCast3D= $RayCast3D
@onready var bomb_sound: AudioStreamPlayer3D = $BombPlacedSound

@export var bomb_scene: PackedScene
var can_act := true


func _enter_tree() -> void:
	var level: DemoLevel  = $"/root/world/Level" #TODO maybe these spawn positions should be global
	position = level.obtain_spawn()
	print(position)

func _ready() -> void:
	camera.make_current()

func _input(event: InputEvent) -> void:
	if not can_act:
		return

	# Handle bomb.
	if event.is_action_pressed("bomb"):
		bomb_sound.play()
		start_cooldown() # TODO instead of this, just avoid placing bomb in the same spot, HOW?
		place_bomb()

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

	target_position = position + target_direction * TILE_SIZE

	if target_position != Vector3.INF:
		ray.target_position =  target_direction * TILE_SIZE
		ray.force_raycast_update()
		if (map.is_position_free(target_position) and !ray.is_colliding()):
			start_cooldown()
			var tween := create_tween()
			tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)


func start_cooldown() -> void:
	can_act = false
	cooldown_timer.start(MOVEMENT_COOLDOWN)

func die() -> void:
	var signal_error = Signals.emit_signal("player_has_died")
	if signal_error:
		printerr("Error on signal: player_has_died")
	queue_free()


func take_damage(how_much: int) -> void:
	PlayerState.current_hp -= how_much
	if PlayerState.current_hp == 0:
		die()

func _on_cooldown_timeout() -> void:
	can_act = true

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		print("%s killed the player" % body.name)
		die()

func place_bomb() -> void:
	var bomb:StaticBody3D = bomb_scene.instantiate()
	# the bomb is created at player's position
	bomb.position = position
	bomb.position.y = 0
	get_parent().add_child(bomb)

