class_name House
extends StaticBody2D

@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var connected_label: Label = $ConnectedLabel


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	connected_label.visible = false


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	if mailbox_collection_component.count() <= 0:
		connected_label.visible = true
