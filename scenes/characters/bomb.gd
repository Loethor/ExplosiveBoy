extends Node3D

@onready var collision := $StaticBody3D/CollisionShape3D

func _ready() -> void:
	collision.disabled = true

func explode() -> void:
	print("BOOM")
	queue_free()

func _on_timer_timeout() -> void:
	explode()
