class_name PickUpComponent
extends Node

signal grabbed
signal placed

@export var sprite: Sprite2D

var is_grabbed: bool


func _physics_process(_delta: float) -> void:
	if not is_grabbed:
		return
	sprite.owner.global_position = sprite.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return
	if is_grabbed:
		is_grabbed = false
		placed.emit()
	elif sprite.get_rect().has_point(sprite.to_local(event.position)):
		is_grabbed = true
		grabbed.emit()

	get_viewport().set_input_as_handled()
