class_name ResidentStateWaiting
extends ResidentState

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		resident.mailbox_collection_component.first_added.connect(_on_first_added)
	else:
		data.DATA_SELECTED_MAILBOX = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, data)


func exit() -> void:
	if resident.mailbox_collection_component.first_added.is_connected(_on_first_added):
		resident.mailbox_collection_component.first_added.disconnect(_on_first_added)


func _on_first_added() -> void:
	var selected_mailbox := resident.get_closest_mailbox()
	_data.DATA_SELECTED_MAILBOX = selected_mailbox
	finished.emit(WALKING_TO_MAILBOX, _data)
