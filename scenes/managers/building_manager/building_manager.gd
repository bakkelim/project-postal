class_name BuildingManager
extends Node

@export var build_ui: BuildUI
@export var grid_manager: GridManager
@export var mailbox_root: Node
@export var house_root: Node

@onready var cursor: Sprite2D = $Cursor


func _ready() -> void:
	cursor.visible = false
	cursor.texture.size = Vector2(GameState.tile_size, GameState.tile_size)
	build_ui.place_mailbox_button_pressed.connect(_on_place_mailbox_button_pressed)


func _process(_delta: float) -> void:
	if not cursor.visible:
		return
	var grid_position := grid_manager.get_mouse_tile_position()
	cursor.global_position = grid_position * GameState.tile_size


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return
	if not cursor.visible:
		return
	if not grid_manager.is_tile_available(grid_manager.get_mouse_tile_position()):
		return

	var instance := Mailbox.new_instance(grid_manager.get_mouse_tile_position())
	mailbox_root.add_child(instance)
	cursor.visible = false

	GameState.state = GameState.States.SELECTING
	get_viewport().set_input_as_handled()


func _on_place_mailbox_button_pressed() -> void:
	cursor.visible = true
	GameState.state = GameState.States.PLACING
