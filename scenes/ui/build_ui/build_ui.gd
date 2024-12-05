class_name BuildUI
extends CanvasLayer

@export var mailbox_parent: Node
@export var grid_manager: GridManager

@onready var mailbox_button: Button = $MarginContainer/HBoxContainer/MailboxButton
@onready var cursor: Sprite2D = $Cursor
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	cursor.visible = false
	mailbox_button.pressed.connect(_on_mailbox_button_pressed)


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
	mailbox_parent.add_child(instance)
	cursor.visible = false
	
	GameState.state = GameState.States.SELECTING
	get_viewport().set_input_as_handled()


func _on_mailbox_button_pressed() -> void:
	cursor.visible = true
	GameState.state = GameState.States.PLACING
