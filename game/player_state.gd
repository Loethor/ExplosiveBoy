extends Node

signal bomb_power_changed(new_value)
signal max_hp_changed()
signal current_hp_changed()

signal max_bombs_changed()
signal current_bombs_changed()

var bomb_power: int = 1:
	get:
		return bomb_power
	set(value):
		bomb_power = value
		bomb_power_changed.emit(bomb_power)
		print(bomb_power)


var max_hp: int = 3:
	get:
		return max_hp
	set(value):
		max_hp = value
		max_hp_changed.emit()

var current_hp: int = 3:
	get:
		return current_hp
	set(value):
		current_hp = value
		current_hp_changed.emit()

var max_bombs: int = 3:
	get:
		return max_bombs
	set(value):
		max_bombs = value
		max_bombs_changed.emit()

var current_bombs: int = 3:
	get:
		return current_bombs
	set(value):
		current_bombs = value
		current_bombs_changed.emit()
