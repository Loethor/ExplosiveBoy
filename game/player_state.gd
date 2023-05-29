extends Node

signal bomb_power_changed(new_value)
signal max_hp_changed(new_value)
signal current_hp_changed(new_value)

var bomb_power: int:
	get:
		return bomb_power
	set(value):
		bomb_power = value
		bomb_power_changed.emit(bomb_power)
		print(bomb_power)


var max_hp: int:
	get:
		return max_hp
	set(value):
		max_hp = value
		max_hp_changed.emit(max_hp)

var current_hp: int:
	get:
		return current_hp
	set(value):
		current_hp = value
		current_hp_changed.emit(current_hp)
