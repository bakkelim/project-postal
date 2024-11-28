class_name CapacityComponent
extends Node2D

signal changed

@export var capacity: int = 0:
	set(value):
		capacity = value
		_update_label()

var is_full: bool
var _number_of_mails: int = 0:
	set(value):
		_number_of_mails = value
		is_full = _number_of_mails >= capacity
		_update_label()

@onready var capacity_label: Label = $CapacityLabel


func update_mailbox(amount: int) -> void:
	_number_of_mails += amount
	changed.emit()


func empty_mailbox() -> void:
	_number_of_mails = 0
	changed.emit()


func _update_label() -> void:
	capacity_label.text = "%s/%s" % [_number_of_mails, capacity]
