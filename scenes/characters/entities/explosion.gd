extends Node3D
class_name Explosion

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Body(%s) entered in explosion." % body)
	if body.is_in_group("enemies"):
		body.die()
	elif body.is_in_group("players"):
		body.die()
	elif body.is_in_group("bombs"):
		body.explode()
