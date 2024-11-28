class_name Resident
extends StaticBody2D

@export var mailbox_collection_component: MailboxCollectionComponent
@export var progress_bar: ProgressBar

var home_position: Vector2

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent


func _ready() -> void:
	produce_mail_component.progress_bar = progress_bar
	await owner.ready
	home_position = owner.global_position


func get_closest_mailbox() -> Mailbox:
	return mailbox_collection_component.get_mailbox_closest_to(global_position)
