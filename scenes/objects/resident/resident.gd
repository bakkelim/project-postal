class_name Resident
extends StaticBody2D

@export var mailbox_collection_component: MailboxCollectionComponent
@export var progress_bar: ProgressBar

var home: House

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent


func _ready() -> void:
	produce_mail_component.progress_bar = progress_bar
	await owner.ready
	home = owner as House
	assert(owner != null, "owner needs to be a House node.")


func get_closest_mailbox() -> Mailbox:
	return mailbox_collection_component.get_mailbox_closest_to(global_position)
