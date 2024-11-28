class_name MailboxCollectionComponent
extends Node

signal first_added

var _collection: Array[Mailbox] = []


func get_collection() -> Array[Mailbox]:
	return _collection


func get_copy() -> Array[Mailbox]:
	return _collection.duplicate()


func get_closest_mailbox() -> Mailbox:
	if _collection.size() <= 0:
		return

	return _collection[0]


func count() -> int:
	return _collection.size()


func add(mailbox: Mailbox) -> void:
	if _collection.has(mailbox):
		return

	_collection.push_back(mailbox)

	if _collection.size() == 1:
		first_added.emit()


func remove(mailbox: Mailbox) -> void:
	_collection.erase(mailbox)


func get_global_positions() -> Array[Vector2]:
	var global_positions: Array[Vector2] = []
	for c in _collection:
		global_positions.push_back(c.global_position)
	return global_positions


func get_mailbox_closest_to(destination: Vector2) -> Mailbox:
	if _collection.size() <= 0:
		return null
	var copy := _collection.duplicate()
	copy.sort_custom(_sort_by_distance_to_destination.bind(destination))
	return copy[0]


func _sort_by_distance_to_destination(
	mailbox1: Mailbox, mailbox2: Mailbox, destination: Vector2
) -> bool:
	var distance_to_mailbox1 := destination.distance_to(mailbox1.global_position)
	var distance_to_mailbox2 := destination.distance_to(mailbox2.global_position)
	return distance_to_mailbox1 < distance_to_mailbox2
