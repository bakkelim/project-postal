class_name ResidentStateWalkingToHouse
extends ResidentState

@export var animate_between_component: AnimateBetweenComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	animate_between_component.animation_finished.connect(_on_animation_finished)
	animate_between_component.start_animation(resident.home_position)


func exit() -> void:
	animate_between_component.stop_animation()
	animate_between_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if _data.DATA_HAS_MAIL:
		finished.emit(WAITING, _data)
	else:
		finished.emit(PRODUCING, _data)
