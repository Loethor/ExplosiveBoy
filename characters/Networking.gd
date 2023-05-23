extends Node

var sync_position: Vector3:
	set(value):
		sync_position = value
		processed_position = false
var processed_position : bool
