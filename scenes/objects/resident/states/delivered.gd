class_name ResidentStateDelivered
extends ResidentState


func enter(_previous_state_path: String, data := {}) -> void:
	var mailbox: Mailbox = data.DATA_SELECTED_MAILBOX
	if not mailbox.is_full:
		mailbox.deposit_mail(data.DATA_MAIL)
		data.DATA_MAIL = null

	finished.emit(WALKING_TO_HOUSE, data)
