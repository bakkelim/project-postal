class_name PostmanStateWalkingToHouse
extends PostmanState

@export var animate_component: AnimateComponent

var _data: Dictionary
var _path: Array[Vector2i]


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	var selected_house: House = postman.get_next_house()
	if not selected_house:
		finished.emit(WALKING_TO_POST_OFFICE, _data)
		return
	var previous_house: House = _data.get(DATA_SELECTED_HOUSE)
	_data[DATA_SELECTED_HOUSE] = selected_house

	animate_component.animation_finished.connect(_on_animation_finished)

	var road_path_manager: RoadPathManager = get_tree().get_first_node_in_group("road_path_manager")
	_path = road_path_manager.get_postman_walking_to_house_path(
		postman, selected_house, previous_house
	)

	if _path.is_empty():
		finished.emit(DELIVERED, _data)
		return

	var cell := _path.pop_front() as Vector2i
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)


func exit() -> void:
	animate_component.stop_animation()
	if animate_component.animation_finished.is_connected(_on_animation_finished):
		animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if _path.is_empty():
		finished.emit(DELIVERED, _data)
		return

	var cell: Vector2i = _path.pop_front()
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)
