class_name BuildUI
extends CanvasLayer

signal place_mailbox_button_pressed

@onready var mailbox_button: Button = $MarginContainer/HBoxContainer/MailboxButton


func _ready() -> void:
	mailbox_button.pressed.connect(_on_mailbox_button_pressed)


func _on_mailbox_button_pressed() -> void:
	place_mailbox_button_pressed.emit()
