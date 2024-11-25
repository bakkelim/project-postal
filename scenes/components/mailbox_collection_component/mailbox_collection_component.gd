class_name MailboxCollectionComponent
extends Node

@export var house: House

var _collection: Array[Mailbox] = []


func get_closest_mailbox() -> Mailbox:
	if _collection.size() <= 0:
		return

	return _collection[0]


func _sort_by_distance_to_house(mailbox1: Mailbox, mailbox2: Mailbox) -> bool:
	var mailbox1_to_house := house.global_position.distance_to(mailbox1.global_position)
	var mailbox2_to_house := house.global_position.distance_to(mailbox2.global_position)
	return mailbox1_to_house < mailbox2_to_house


func count() -> int:
	return _collection.size()


func add(mailbox: Mailbox) -> void:
	if _collection.has(mailbox):
		return

	_collection.push_back(mailbox)
	_collection.sort_custom(_sort_by_distance_to_house)


func remove(mailbox: Mailbox) -> void:
	_collection.erase(mailbox)
	_collection.sort_custom(_sort_by_distance_to_house)
