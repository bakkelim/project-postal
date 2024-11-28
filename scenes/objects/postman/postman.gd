class_name Postman
extends StaticBody2D

enum Tasks { COLLECTING, SORTING, DELIVERING }

@export var mailbox_collection_component: MailboxCollectionComponent

var current_task: Tasks = Tasks.COLLECTING
var current_mailbox: Mailbox
var post_office_position: Vector2

@onready var animate_between_component: AnimateBetweenComponent = $AnimateBetweenComponent
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	await owner.ready
	post_office_position = owner.global_position
