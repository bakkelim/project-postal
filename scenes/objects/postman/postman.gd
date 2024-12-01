class_name Postman
extends StaticBody2D

enum Tasks { IDLE, COLLECTING, SORTING, DELIVERING }

@export var mailbox_collection_component: MailboxCollectionComponent

var current_task: Tasks
var working_place: PostOffice
var collected_mail: Array[Mail] = []

@onready var animate_between_component: AnimateBetweenComponent = $AnimateBetweenComponent
@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	await owner.ready
	working_place = owner as PostOffice
	assert(working_place != null, "owner needs to be a PostOffice node.")


func update_task() -> void:
	if current_task == Tasks.IDLE:
		current_task = Tasks.COLLECTING
	elif current_task == Tasks.COLLECTING:
		current_task = Tasks.SORTING
	elif current_task == Tasks.SORTING:
		current_task = Tasks.COLLECTING
	#elif current_task == Tasks.DELIVERING:
	#current_task = Tasks.COLLECTING
