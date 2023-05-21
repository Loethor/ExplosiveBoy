extends CharacterBody3D

@onready var nav =  $NavigationAgent3D
const SPEED = 100.0
@onready var tar = $"../Target"

func _ready() -> void:
	nav.set_target_position(tar.global_position)

func _physics_process(delta: float) -> void:
	var current_location = global_position
	var next_location = nav.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED * delta

	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav.set_target_position(target_location)
