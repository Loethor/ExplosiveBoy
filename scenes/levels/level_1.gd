extends Node3D

@export var grid_map := GridMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	World.has_exploded.connect(_explosion_on_area.bind())

func _explosion_on_area(area:Vector2):
	print("Exploded on %s" % area)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
