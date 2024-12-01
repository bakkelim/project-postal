class_name ResidentStateIdle
extends ResidentState

@export var produce_mail_component: ProduceMailComponent

var _data: Dictionary


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data

	while get_tree().get_node_count_in_group("houses") <= 1:
		await get_tree().create_timer(.5).timeout

	produce_mail_component.mail_produced.connect(_on_mail_produced)
	produce_mail_component.produce_mail()


func exit() -> void:
	produce_mail_component.mail_produced.disconnect(_on_mail_produced)


func _on_mail_produced(mail: Mail) -> void:
	_data.DATA_MAIL = mail

	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		finished.emit(WAITING, _data)
	else:
		_data.DATA_SELECTED_MAILBOX = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, _data)
