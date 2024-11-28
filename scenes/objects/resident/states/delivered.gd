class_name ResidentStateDelivered
extends ResidentState


func enter(_previous_state_path: String, data := {}) -> void:
	data.DATA_HAS_MAIL = false
	var mailbox: Mailbox = data.DATA_SELECTED_MAILBOX
	mailbox.deliver_mail()

	finished.emit(WALKING_TO_HOUSE, data)
