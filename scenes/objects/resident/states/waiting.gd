class_name ResidentStateWaiting
extends ResidentState

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		resident.mailbox_collection_component.collection_changed.connect(_on_first_added)
	else:
		data[DATA_SELECTED_MAILBOX] = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, data)


func exit() -> void:
	if resident.mailbox_collection_component.collection_changed.is_connected(_on_first_added):
		resident.mailbox_collection_component.collection_changed.disconnect(_on_first_added)


func _on_first_added() -> void:
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		return
	_data[DATA_SELECTED_MAILBOX] = selected_mailbox
	finished.emit(WALKING_TO_MAILBOX, _data)
