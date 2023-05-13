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
	print("Initial position: %s" % position)
	# move the raycast to the new position
	ray.target_position = DIRECTIONS[direction] * TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += DIRECTIONS[direction] * TILE_SIZE
		print("After position: %s" % position)

func place_bomb():
	var bomb := bomb_scene.instantiate()
	bomb.position = position
	get_parent().add_child(bomb)



