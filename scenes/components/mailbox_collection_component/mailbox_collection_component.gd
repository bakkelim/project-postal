class_name MailCollectionComponent
extends Node

var collection: Array[Mailbox] = []


func add(mailbox: Mailbox) -> void:
	if collection.has(mailbox):
		return

	collection.push_back(mailbox)
	print(collection)


func remove(mailbox: Mailbox) -> void:
	collection.erase(mailbox)
	print(collection)
