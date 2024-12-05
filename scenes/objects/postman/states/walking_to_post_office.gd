class_name PostmanStateWalkingToPostOffice
extends PostmanState

@export var animate_component: AnimateComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	animate_component.animation_finished.connect(_on_animation_finished)
	animate_component.start_animation(postman.working_place.global_position)


func exit() -> void:
	animate_component.stop_animation()
	animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	finished.emit(START_TASK, _data)
