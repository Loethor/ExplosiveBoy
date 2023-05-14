extends Control

@onready var ui := $"."
@onready var main_menu := $MainMenu
@onready var level_selector := $LevelSelector
#@onready var tween = get_tree().create_tween()

var menu_original_position := Vector2.ZERO
var menu_original_size := Vector2.ZERO
const MENU_TRANSITION_TIME := 0.25

var current_menu
var menu_stack := []


func _ready() -> void:
	menu_original_position = Vector2(0,0)
	menu_original_size = get_viewport_rect().size
	current_menu = main_menu


func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		ui.visible = !ui.visible
		if ui.visible:
			reset_menus()
			get_tree().paused = true
		else:
			get_tree().paused = false


func move_to_next_menu(next_menu_id: String):
	var next_menu = get_menu_from_menu_id(next_menu_id)
#	current_menu.global_position = Vector2(-menu_original_size.x,0)
#	next_menu.global_position = menu_original_position
	var tween = create_tween()
	tween.tween_property(current_menu, "global_position", Vector2(-menu_original_size.x,0), MENU_TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(next_menu, "global_position", menu_original_position, MENU_TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR)
	menu_stack.append(current_menu)
	current_menu = next_menu



func move_to_previous_menu():
	var previous_menu = menu_stack.pop_back()
	if previous_menu != null:
#		previous_menu.global_position = menu_original_position
#		current_menu.global_position = Vector2(menu_original_size.x,0)
		var tween = create_tween()
		tween.tween_property(current_menu, "global_position", Vector2(menu_original_size.x,0), MENU_TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(previous_menu, "global_position", menu_original_position, MENU_TRANSITION_TIME).set_trans(Tween.TRANS_LINEAR)

		current_menu = previous_menu

func get_menu_from_menu_id(menu_id: String) -> Control:
	match menu_id:
		"main_menu": return main_menu
		"level_selector": return level_selector
		_: return main_menu

func reset_menus():
	main_menu.global_position = menu_original_position
	level_selector.global_position = Vector2(menu_original_size.x,0)
	current_menu = main_menu
	menu_stack = []

func _on_play_button_pressed() -> void:
	move_to_next_menu("level_selector")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	move_to_previous_menu()

func _on_level_1_button_pressed() -> void:
	get_parent().get_parent().load_level("level_1")
	ui.visible = false

func _on_level_2_button_pressed() -> void:
	get_parent().get_parent().load_level("level_2")
	ui.visible = false

func _on_level_3_button_pressed() -> void:
	get_parent().get_parent().load_level("level_3")
	ui.visible = false
