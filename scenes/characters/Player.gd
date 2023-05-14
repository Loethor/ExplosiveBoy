extends CharacterBody3D


const TILE_SIZE = 1
const DIRECTIONS = {"right": Vector3.RIGHT,
				"left": Vector3.LEFT,
				"up": Vector3.FORWARD,
				"down": Vector3.BACK}

@onready var ray := $RayCast3D
var bomb_scene := preload("res://scenes/characters/bomb.tscn")

func _unhandled_input(event):
	for direction in DIRECTIONS.keys():
		if event.is_action_pressed(direction):
			move(direction)

	if event.is_action_pressed("bomb"):
		place_bomb()

func move(direction):

	# move the raycast to the new position
	ray.target_position = DIRECTIONS[direction] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += DIRECTIONS[direction] * TILE_SIZE
		print("Player position position: %s" % position)
		print("Player position position: %s" % global_position)

func place_bomb():
	var bomb := bomb_scene.instantiate()

	# the bomb is created at player's position
	bomb.position = position
	bomb.position.y = 0
	print("Bomb placed at %s" % bomb.position)
	print("Bomb placed at %s" % bomb.global_position)
	get_parent().add_child(bomb)



