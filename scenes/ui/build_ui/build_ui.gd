class_name BuildUI
extends CanvasLayer

@export var mailbox_parent: Node

@onready var mailbox_button: Button = $MarginContainer/HBoxContainer/MailboxButton
@onready var cursor: Sprite2D = $Cursor
@onready var margin_container: MarginContainer = $MarginContainer


func _ready() -> void:
	cursor.visible = false
	mailbox_button.pressed.connect(_on_mailbox_button_pressed)


func _process(_delta: float) -> void:
	if not cursor.visible:
		return
	var grid_position := _get_mouse_grid_cell_position()
	cursor.global_position = grid_position * 64


func _get_mouse_grid_cell_position() -> Vector2i:
	var mouse_position := margin_container.get_global_mouse_position()
	var grid_position := mouse_position / 64
	grid_position = grid_position.floor()
	return grid_position


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return
	if not cursor.visible:
		return

	var instance := Mailbox.new_instance()
	mailbox_parent.add_child(instance)
	instance.global_position = _get_mouse_grid_cell_position() * 64
	cursor.visible = false
	get_viewport().set_input_as_handled()


func _on_mailbox_button_pressed() -> void:
	cursor.visible = true
