class_name BuildingManager
extends Node

@export var build_ui: BuildUI
@export var grid_manager: GridManager
@export var mailbox_root: Node
@export var house_root: Node
@export var spawn_manager: SpawnManager

@onready var cursor: Sprite2D = $Cursor


func _ready() -> void:
	cursor.visible = false
	build_ui.place_mailbox_button_pressed.connect(_on_place_mailbox_button_pressed)
	spawn_manager.spawn_timeout.connect(_on_spawn_timeout)


func _process(_delta: float) -> void:
	if not cursor.visible:
		return
	var grid_position := grid_manager.get_mouse_tile_position()
	cursor.global_position = grid_position * 64


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


func _on_spawn_timeout() -> void:
	var start_tile := grid_manager.get_random_free_area(Vector2i(2, 2))
	if start_tile == Vector2.ZERO:
		return
	var instance := House.new_instance(start_tile)
	house_root.add_child(instance)
