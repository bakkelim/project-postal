class_name MailCollectionComponent
extends Node

var _collection: Array[Mailbox] = []


func count() -> int:
	return _collection.size()


func add(mailbox: Mailbox) -> void:
	if _collection.has(mailbox):
		return
	_collection.push_back(mailbox)


func remove(mailbox: Mailbox) -> void:
	_collection.erase(mailbox)
