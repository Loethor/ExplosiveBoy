extends CharacterBody3D


const SPEED = 5.0

const TILE_SIZE = 1
const INPUTS = {"right": Vector3.RIGHT,
				"left": Vector3.LEFT,
				"up": Vector3.FORWARD,
				"down": Vector3.BACK}

@onready var ray := $RayCast3D

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move(dir)

#func _physics_process(delta: float) -> void:
#	# Add the gravity.
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	position = position.snapped(Vector3.ONE * TILE_SIZE)
#	position += Vector3.ONE * TILE_SIZE/2
#	var input_dir := Input.get_vector("left", "right", "up", "down")
#	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
#	print(direction)
#	direction = direction.floor()
#	print(direction)
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func move(dir):
	print("Initial position: %s", position)
	ray.target_position = INPUTS[dir] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += INPUTS[dir] * TILE_SIZE
		print("After position: %s", position)
