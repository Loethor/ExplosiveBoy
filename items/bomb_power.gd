extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("baseAction")

func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		PlayerState.bomb_power += 1
		queue_free()
