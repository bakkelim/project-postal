class_name PostmanStateCollected
extends PostmanState


func enter(_previous_state_path: String, data := {}) -> void:
	var mail := _collect_mail(data)

	var mailboxes_to_visit: Array[Mailbox] = data.DATA_MAILBOXES_TO_VISIT
	if mailboxes_to_visit.size() <= 0:
		finished.emit(WALKING_TO_POST_OFFICE, data)
	else:
		var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
		data.DATA_SELECTED_MAILBOX = selected_mailbox
		data.DATA_MAILBOXES_TO_VISIT = mailboxes_to_visit
		finished.emit(WALKING_TO_MAILBOX, data)


func _collect_mail(data: Dictionary) -> Array[Mail]:
	if data.DATA_SELECTED_MAILBOX is Mailbox:
		return (data.DATA_SELECTED_MAILBOX as Mailbox).capacity_component.collect_mail()
	return []
