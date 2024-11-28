class_name PostmanStateWalkingToPostOffice
extends PostmanState

@export var animate_between_component: AnimateBetweenComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	animate_between_component.animation_finished.connect(_on_animation_finished)
	animate_between_component.start_animation(postman.post_office_position)


func exit() -> void:
	animate_between_component.stop_animation()
	animate_between_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	finished.emit(COLLECTING, _data)
