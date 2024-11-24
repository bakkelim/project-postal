class_name MailboxCollectionComponent
extends Node

signal connected
signal disconnected

var _collection: Array[Mailbox] = []


func get_mailbox() -> Mailbox:
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
		connected.emit()


func remove(mailbox: Mailbox) -> void:
	_collection.erase(mailbox)

	if _collection.size() <= 0:
		disconnected.emit()
