class_name PickUpComponent
extends Node

signal grabbed
signal placed

@export var sprite: Sprite2D

var is_grabbed: bool


func _physics_process(_delta: float) -> void:
	if not is_grabbed:
		return
	var cell := GridManager.position_to_cell(owner.get_global_mouse_position())
	owner.global_position = cell * GameState.tile_size


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return

	if is_grabbed:
		var grid_manager: GridManager = get_tree().get_first_node_in_group("grid_manager")
		var cell := GridManager.position_to_cell(owner.get_global_mouse_position())
		if not grid_manager.is_road_cell(cell):
			return
		is_grabbed = false
		placed.emit()
		GameState.state = GameState.States.SELECTING
		get_viewport().set_input_as_handled()
	elif GameState.state == GameState.States.PLACING:
		return
	elif sprite.get_rect().has_point(sprite.to_local(event.position)):
		is_grabbed = true
		grabbed.emit()
		GameState.state = GameState.States.PLACING
		get_viewport().set_input_as_handled()
