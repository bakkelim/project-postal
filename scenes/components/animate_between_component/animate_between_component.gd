class_name AnimateBetweenComponent
extends Node

signal animation_finished

@export var sprite: Sprite2D
@export var speed: float = 100.0

var tween: Tween


func start_animation(from: Vector2, to: Vector2) -> void:
	sprite.global_position = from

	var distance := from.distance_to(to)
	var animation_time := distance / speed

	tween = create_tween()
	tween.tween_property(sprite, "global_position", to, animation_time)
	tween.tween_callback(_on_animation_finished)


func cancel_animation():
	if tween and tween.is_running():
		tween.stop()


func _on_animation_finished() -> void:
	animation_finished.emit()
