extends Node3D
class_name Explosion

func _on_timer_timeout() -> void:
	queue_free()
