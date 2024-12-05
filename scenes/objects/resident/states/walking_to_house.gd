class_name ResidentStateWalkingToHouse
extends ResidentState

@export var animate_component: AnimateComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	animate_component.animation_finished.connect(_on_animation_finished)
	animate_component.start_animation(resident.home.global_position)


func exit() -> void:
	animate_component.stop_animation()
	animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if _data.DATA_MAIL:
		finished.emit(WAITING, _data)
	else:
		finished.emit(PRODUCING, _data)
