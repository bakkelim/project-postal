class_name AnimateComponent
extends Node

signal animation_finished

@export var body: StaticBody2D
@export var speed: float = 100.0

var tween: Tween


func start_animation(destination: Vector2) -> void:
	var from: Vector2 = body.global_position

	var distance := from.distance_to(destination)
	var animation_time := distance / speed

	tween = create_tween()
	tween.tween_property(body, "global_position", destination, animation_time)
	tween.tween_callback(_on_animation_finished)


func stop_animation():
	if tween and tween.is_running():
		tween.stop()


func _on_animation_finished() -> void:
	animation_finished.emit()
