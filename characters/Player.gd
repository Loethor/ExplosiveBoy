extends CharacterBody3D
class_name Player

const TILE_SIZE = 1
const MOVEMENT_DURATION = 0.15
const MOVEMENT_COOLDOWN = 0.15
const DIRECTIONS = {"right": Vector3.RIGHT,
					"left": Vector3.LEFT,
					"up": Vector3.FORWARD,
					"down": Vector3.BACK}

@onready var cooldown_timer = $CooldownTimer
@onready var grid = $"/root/world/Level/MapComponent"
@onready var camera := $PlayerCamera
@onready var networking := $Networking
@onready var synchronizer = $Networking/MultiplayerSynchronizer

@export var bomb_scene : PackedScene
var can_act := true



func is_local_authority():
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _enter_tree() -> void:
	position = $"/root/world/Level".obtain_spawn()

func _ready():
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if is_local_authority():
		$PlayerCamera.make_current()

func _physics_process(delta):
	if !is_local_authority():
		if not $Networking.processed_position:
			position = $Networking.sync_position
			$Networking.processed_position = true

		#handle movement TODO move_and_slide()
		return


	# Handle bomb.
	if Input.is_action_pressed("bomb") and can_act:
		place_bomb() # TODO


	var target_position = Vector3.INF
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("right") and can_act:
		target_position = global_position + DIRECTIONS["right"] * TILE_SIZE
	if Input.is_action_pressed("left") and can_act:
		target_position = global_position + DIRECTIONS["left"] * TILE_SIZE
	if Input.is_action_pressed("up") and can_act:
		target_position = global_position + DIRECTIONS["up"] * TILE_SIZE
	if Input.is_action_pressed("down") and can_act:
		target_position = global_position + DIRECTIONS["down"] * TILE_SIZE

	if target_position != Vector3.INF:
		print(global_position)
		print(position)
		print(target_position)
		if (grid.is_position_free(target_position)):
			start_cooldown()
			var tween := create_tween()
			tween.tween_property(self, "position", target_position, MOVEMENT_DURATION).set_trans(Tween.TRANS_LINEAR)
#			global_position = target_position
			networking.sync_position = position

	# Update sync variables, which will be replicated to everyone else
	$Networking.sync_position = position




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
#	queue_free()

func _on_cooldown_timeout() -> void:
	can_act = true

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		print("%s killed the player" % body.name)
#		die()
