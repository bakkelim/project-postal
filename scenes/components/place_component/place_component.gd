class_name PlaceComponent
extends Node

@export var sprite: Sprite2D

var is_dragging: bool


func _physics_process(_delta: float) -> void:
	if not is_dragging:
		return
	sprite.owner.global_position = sprite.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("mouse_left"):
		return
	if is_dragging:
		is_dragging = false
	elif sprite.get_rect().has_point(sprite.to_local(event.position)):
		is_dragging = true

	get_viewport().set_input_as_handled()
