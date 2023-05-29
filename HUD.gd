extends Control

@onready var hp_bar: ProgressBar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.max_hp_changed.connect(update_hud)
	PlayerState.current_hp_changed.connect(update_hud)
	update_hud()


func update_hud() -> void:
	hp_bar.max_value = PlayerState.max_hp
	hp_bar.value = PlayerState.current_hp
	print(PlayerState.current_hp)
