class_name PickUpComponent
extends Node

signal grabbed
signal placed

@export var sprite: Sprite2D

var is_grabbed: bool


func _physics_process(_delta: float) -> void:
	if not is_grabbed:
		return
	var grid_position := _position_to_grid(sprite.get_global_mouse_position())
	sprite.owner.global_position = grid_position * GameState.tile_size


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return

	if is_grabbed:
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


func _position_to_grid(position: Vector2) -> Vector2i:
	var grid_position := position / GameState.tile_size
	grid_position = grid_position.floor()
	return grid_position
