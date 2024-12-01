class_name CapacityComponent
extends Node2D

signal changed

@export var capacity: int = 0:
	set(value):
		capacity = value
		_update_label()

var _mails: Array[Mail] = []

@onready var capacity_label: Label = $CapacityLabel


func deposit_mail(mail: Mail) -> void:
	_mails.push_back(mail)
	_update_label()
	changed.emit()


func collect_mail() -> Array[Mail]:
	var mails := _mails
	_mails = []
	_update_label()
	changed.emit()
	return mails


func is_full() -> bool:
	return _mails.size() >= capacity


func _update_label() -> void:
	capacity_label.text = "%s/%s" % [_mails.size(), capacity]
