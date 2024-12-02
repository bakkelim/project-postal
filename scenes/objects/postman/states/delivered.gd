class_name PostmanStateDelivered
extends PostmanState


func enter(_previous_state_path: String, data := {}) -> void:
	var selected_house: House = data.DATA_SELECTED_HOUSE
	selected_house.received_mail_count += 1
	finished.emit(WALKING_TO_HOUSE, data)
