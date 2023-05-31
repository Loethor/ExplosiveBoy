extends Node3D


func _on_detection_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		PlayerState.max_bombs += 1
		queue_free()
