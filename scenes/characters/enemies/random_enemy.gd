extends CharacterBody3D

@onready var behavior_component :BehaviorComponent = $BehaviorComponent

func _ready() -> void:
	behavior_component.move()

func die():
	queue_free()
