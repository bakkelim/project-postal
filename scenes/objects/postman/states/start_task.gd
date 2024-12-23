class_name PostmanStateStartTask
extends PostmanState

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	postman.update_task()
	if postman.current_task == postman.Tasks.COLLECTING:
		var mailboxes_to_visit := postman.mailbox_collection_component.get_copy()
		if mailboxes_to_visit.size() <= 0:
			postman.mailbox_collection_component.collection_changed.connect(_on_first_added)
		else:
			var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
			data[DATA_SELECTED_MAILBOX] = selected_mailbox
			data[DATA_MAILBOXES_TO_VISIT] = mailboxes_to_visit
			finished.emit(WALKING_TO_MAILBOX, data)
	elif postman.current_task == postman.Tasks.SORTING:
		finished.emit(SORTING, _data)
	elif postman.current_task == postman.Tasks.DELIVERING:
		finished.emit(WALKING_TO_HOUSE, _data)


func exit() -> void:
	if postman.mailbox_collection_component.collection_changed.is_connected(_on_first_added):
		postman.mailbox_collection_component.collection_changed.disconnect(_on_first_added)


func _on_first_added() -> void:
	var mailboxes_to_visit := postman.mailbox_collection_component.get_copy()
	var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
	_data[DATA_SELECTED_MAILBOX] = selected_mailbox
	_data[DATA_MAILBOXES_TO_VISIT] = mailboxes_to_visit
	finished.emit(WALKING_TO_MAILBOX, _data)
