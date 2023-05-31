extends Control

@onready var hp_bar: ProgressBar = $HealthBar
@onready var bomb_texture:Texture2D = load("res://bomb.png")
@onready var bombs_container = $Bombs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerState.max_hp_changed.connect(update_hud)
	PlayerState.current_hp_changed.connect(update_hud)
	PlayerState.max_bombs_changed.connect(update_hud)
	PlayerState.current_bombs_changed.connect(update_hud)
	update_hud()


func update_hud() -> void:
	hp_bar.max_value = PlayerState.max_hp
	hp_bar.value = PlayerState.current_hp
	while bombs_container.get_child_count() != PlayerState.max_bombs:
		var bomb_rect:TextureRect = TextureRect.new()
		bomb_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		bomb_rect.texture = bomb_texture
		bombs_container.add_child(bomb_rect)
	for i in range(PlayerState.max_bombs):
		bombs_container.get_child(i).hide()
	for i in range(PlayerState.current_bombs):
		bombs_container.get_child(i).show()
	print(PlayerState.current_hp)
