class_name House
extends StaticBody2D

static var house_counter := 0

var id: String

@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var connected_label: Label = $ConnectedLabel


func _init() -> void:
	house_counter += 1
	id = "House%s" % [house_counter]


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	connected_label.visible = false


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	if mailbox_collection_component.count() <= 0:
		connected_label.visible = true
