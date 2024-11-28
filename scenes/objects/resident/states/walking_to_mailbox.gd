class_name ResidentStateWalkingToMailbox
extends ResidentState

@export var animate_between_component: AnimateBetweenComponent

var _data: Dictionary
var _selected_mailbox: Mailbox


func enter(_previous_state_path: String, data := {}) -> void:
	_data = data

	_selected_mailbox = data.DATA_SELECTED_MAILBOX
	_selected_mailbox.full.connect(_on_mailbox_full)
	_selected_mailbox.grabbed.connect(_on_mailbox_grabbed)
	#_selected_mailbox.placed.connect(_on_mailbox_placed)

	animate_between_component.animation_finished.connect(_on_animation_finished)
	animate_between_component.start_animation(_selected_mailbox.global_position)


func exit() -> void:
	animate_between_component.stop_animation()
	animate_between_component.animation_finished.disconnect(_on_animation_finished)
	_selected_mailbox.full.disconnect(_on_mailbox_full)
	_selected_mailbox.grabbed.disconnect(_on_mailbox_grabbed)
	#_selected_mailbox.placed.disconnect(_on_mailbox_placed)


func _on_animation_finished() -> void:
	finished.emit(DELIVERED, _data)


func _on_mailbox_full() -> void:
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		finished.emit(WALKING_TO_HOUSE, _data)
	else:
		_data.DATA_SELECTED_MAILBOX = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, _data)


func _on_mailbox_grabbed() -> void:
	var selected_mailbox := resident.get_closest_mailbox()
	if not selected_mailbox:
		finished.emit(WALKING_TO_HOUSE, _data)
	else:
		_data.DATA_SELECTED_MAILBOX = selected_mailbox
		finished.emit(WALKING_TO_MAILBOX, _data)

#func _on_mailbox_placed() -> void:
#var selected_mailbox := resident.get_closest_mailbox()
#if not selected_mailbox:
#finished.emit(WALKING_TO_HOUSE, _data)
#else:
#_data.DATA_SELECTED_MAILBOX = selected_mailbox
#finished.emit(WALKING_TO_MAILBOX, _data)
