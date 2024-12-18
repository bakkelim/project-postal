class_name Resident
extends StaticBody2D

@export var mailbox_collection_component: MailboxCollectionComponent
@export var progress_bar: ProgressBar

var home: House
var _sprite_with_mail: Texture2D = preload("res://assets/person-1.png")
var _sprite_without_mail: Texture2D = preload("res://assets/person-1-no-package.png")

@onready var _produce_mail_component: ProduceMailComponent = $ProduceMailComponent
@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_produce_mail_component.progress_bar = progress_bar
	await owner.ready
	home = owner as House
	assert(owner != null, "owner needs to be a House node.")


func get_closest_mailbox() -> Mailbox:
	return mailbox_collection_component.get_mailbox_closest_to(global_position)


func update_sprite_with_mail() -> void:
	_sprite.texture = _sprite_with_mail


func update_sprite_without_mail() -> void:
	_sprite.texture = _sprite_without_mail
