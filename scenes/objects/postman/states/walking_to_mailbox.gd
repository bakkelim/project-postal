class_name PostmanStateWalkingToMailbox
extends PostmanState

@export var animate_component: AnimateComponent

var _data: Dictionary
var _selected_mailbox: Mailbox


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data
	_selected_mailbox = data.DATA_SELECTED_MAILBOX
	animate_component.animation_finished.connect(_on_animation_finished)
	animate_component.start_animation(_selected_mailbox.get_center_position())
	_selected_mailbox.grabbed.connect(_on_mailbox_grabbed)


func exit() -> void:
	_selected_mailbox.grabbed.disconnect(_on_mailbox_grabbed)
	animate_component.stop_animation()
	animate_component.animation_finished.disconnect(_on_animation_finished)


func _on_animation_finished() -> void:
	finished.emit(COLLECTED, _data)


func _on_mailbox_grabbed() -> void:
	var mailboxes_to_visit: Array[Mailbox] = _data.DATA_MAILBOXES_TO_VISIT
	var selected_mailbox: Mailbox = mailboxes_to_visit.pop_back()
	_data.DATA_SELECTED_MAILBOX = selected_mailbox
	_data.DATA_MAILBOXES_TO_VISIT = mailboxes_to_visit

	if not selected_mailbox:
		finished.emit(WALKING_TO_POST_OFFICE, _data)
	else:
		finished.emit(WALKING_TO_MAILBOX, _data)
