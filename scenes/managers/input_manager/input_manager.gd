class_name InputManager
extends Node

enum States { SELECTION, PLACEMENT }

var state: States = States.SELECTION


func _ready() -> void:
	Events.bulding_grabbed.connect(_on_bulding_grabbed)
	Events.bulding_grabbed.connect(_on_bulding_grabbed)

#func _input(event: InputEvent) -> void:
	#match state:
		#States.SELECTION:
			#_handle_selection_input(event)
		#States.PLACEMENT:
			#_handle_placement_input(event)


func _handle_selection_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("mouse_left"):
		#_open_train_inventory()
	#if event.is_action_pressed("player_inventory"):
		#_open_player_inventory()

func _handle_placement_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("inventory_open"):
		#_close_train_inventory()
	#state = States.ACTIVE


func _on_bulding_grabbed() -> void:
	state = States.PLACEMENT


func _on_bulding_placed() -> void:
	state = States.SELECTION
