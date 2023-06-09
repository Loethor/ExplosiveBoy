extends Node3D
class_name Explosion

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemies"):
		body.die()
	elif body.is_in_group("players"):
		body.die()

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().is_in_group("bombs") and not area.get_parent().is_exploding:
		area.get_parent().explode()

