class_name PostmanStateWalkingToHouse
extends PostmanState

@export var animate_component: AnimateComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	var selected_house: House = postman.get_next_house()
	if not selected_house:
		finished.emit(WALKING_TO_POST_OFFICE, _data)
		return
	_data.DATA_SELECTED_HOUSE = selected_house
	animate_component.animation_finished.connect(_on_animation_finished)
	animate_component.start_animation(selected_house.get_center_position())


func exit() -> void:
	animate_component.stop_animation()
	if animate_component.animation_finished.is_connected(_on_animation_finished):
		animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	finished.emit(DELIVERED, _data)
