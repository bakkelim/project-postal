class_name PostmanStateWalkingToMailbox
extends PostmanState

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
	_path = road_path_manager.get_postman_walking_to_mailbox_path(postman, _selected_mailbox)

	if _path.is_empty():
		finished.emit(COLLECTED, _data)
		return

	var cell: Vector2i = _path.pop_front()
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)


func exit() -> void:
	_selected_mailbox.grabbed.disconnect(_on_mailbox_grabbed)
	animate_component.stop_animation()
	animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	if _path.is_empty():
		finished.emit(COLLECTED, _data)
		return

	var cell: Vector2i = _path.pop_front()
	var position := GridManager.cell_to_position(cell)
	animate_component.start_animation(position)


func _on_mailbox_grabbed() -> void:
	var mailboxes_to_visit: Array[Mailbox] = _data[DATA_MAILBOXES_TO_VISIT]
	var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
	_data[DATA_SELECTED_MAILBOX] = selected_mailbox
	_data[DATA_MAILBOXES_TO_VISIT] = mailboxes_to_visit

	if not selected_mailbox:
		finished.emit(WALKING_TO_POST_OFFICE, _data)
	else:
		finished.emit(WALKING_TO_MAILBOX, _data)
