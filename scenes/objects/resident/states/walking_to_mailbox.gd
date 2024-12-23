class_name ResidentStateWalkingToMailbox
extends ResidentState

@export var animate_component: AnimateComponent

var _data: Dictionary
var _selected_mailbox: Mailbox

var _path: Array[Vector2i]


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data

	_selected_mailbox = data[DATA_SELECTED_MAILBOX]
	_selected_mailbox.grabbed.connect(_on_mailbox_grabbed)

	animate_component.animation_finished.connect(_on_animation_finished)

	var road_path_manager: RoadPathManager = get_tree().get_first_node_in_group("road_path_manager")
	_path = road_path_manager.get_resident_walking_to_mailbox_path(resident, _selected_mailbox)

	if _path.is_empty():
		finished.emit(DELIVERED, _data)
		return

	var cell: Vector2i = _path.pop_front()
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)


func exit() -> void:
	animate_component.stop_animation()
	animate_component.animation_finished.disconnect(_on_animation_finished)
	_selected_mailbox.grabbed.disconnect(_on_mailbox_grabbed)


func _on_animation_finished() -> void:
	if _path.is_empty():
		finished.emit(DELIVERED, _data)
		return

	var cell: Vector2i = _path.pop_front()
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)


func _on_mailbox_grabbed() -> void:
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		finished.emit(WALKING_TO_HOUSE, _data)
	else:
		_data[DATA_SELECTED_MAILBOX] = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, _data)
