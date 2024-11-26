class_name CapacityComponent
extends Node2D

signal full

@export var capacity: int = 0:
	set(value):
		capacity = value
		_update_label()

var number_of_mails: int = 0:
	set(value):
		number_of_mails = value
		_update_label()

@onready var capacity_label: Label = $CapacityLabel


func update_mailbox(amount: int) -> void:
	number_of_mails += amount
	if number_of_mails >= capacity:
		full.emit()


func _update_label() -> void:
	capacity_label.text = "%s/%s" % [number_of_mails, capacity]
