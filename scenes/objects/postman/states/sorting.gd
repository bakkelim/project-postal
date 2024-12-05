class_name PostmanStateSorting
extends PostmanState

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data

	await get_tree().create_timer(1).timeout

	finished.emit(START_TASK, _data)
