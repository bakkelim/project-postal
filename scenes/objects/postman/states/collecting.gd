class_name PostmanStateCollecting
extends PostmanState

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	var mailboxes_to_visit := postman.mailbox_collection_component.get_copy()
	if mailboxes_to_visit.size() <= 0:
		postman.mailbox_collection_component.first_added.connect(_on_first_added)
	else:
		var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
		data.DATA_SELECTED_MAILBOX = selected_mailbox
		data.DATA_MAILBOXES_TO_VISIT = mailboxes_to_visit
		finished.emit(WALKING_TO_MAILBOX, data)


func exit() -> void:
	if postman.mailbox_collection_component.first_added.is_connected(_on_first_added):
		postman.mailbox_collection_component.first_added.disconnect(_on_first_added)


func _on_first_added() -> void:
	var mailboxes_to_visit := postman.mailbox_collection_component.get_copy()
	var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
	_data.DATA_SELECTED_MAILBOX = selected_mailbox
	_data.DATA_MAILBOXES_TO_VISIT = mailboxes_to_visit
	finished.emit(WALKING_TO_MAILBOX, _data)
