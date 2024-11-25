class_name House
extends StaticBody2D

enum States { IDLE, PRODUCING, WAITING, DELIVERING, DELIVERED, RETURNING }

var state: States = States.IDLE:
	set = _set_state
var has_mailbox: bool
var has_mail: bool
var traveling_to_mailbox: Mailbox

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent
@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var connected_label: Label = $ConnectedLabel
@onready var animate_between_component: AnimateBetweenComponent = $AnimateBetweenComponent
@onready var resident_sprite: Sprite2D = $ResidentSprite


func _ready() -> void:
	produce_mail_component.mail_produced.connect(_on_mail_produced)
	state = States.PRODUCING
	resident_sprite.visible = false


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	has_mailbox = true
	connected_label.visible = false
	if state == States.WAITING:
		state = States.DELIVERING


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	if mailbox_collection_component.count() <= 0:
		has_mailbox = false
		connected_label.visible = true

	if state == States.DELIVERING and mailbox == traveling_to_mailbox:
		state = States.RETURNING


func _set_state(new_state: int) -> void:
	var previous_state := state
	state = new_state

	if previous_state == States.PRODUCING:
		has_mail = true
	if previous_state == States.DELIVERING:
		animate_between_component.animation_finished.disconnect(_on_delivered)
		animate_between_component.cancel_animation()
	if previous_state == States.RETURNING:
		animate_between_component.animation_finished.disconnect(_on_returned)
		resident_sprite.visible = false

	if state == States.PRODUCING:
		produce_mail_component.produce_mail()
	if state == States.WAITING:
		if has_mailbox:
			state = States.DELIVERING
	if state == States.DELIVERING:
		animate_between_component.animation_finished.connect(_on_delivered)
		resident_sprite.visible = true
		traveling_to_mailbox = mailbox_collection_component.get_closest_mailbox()
		animate_between_component.start_animation(
			global_position, traveling_to_mailbox.global_position
		)
	if state == States.DELIVERED:
		has_mail = false
		state = States.RETURNING
	if state == States.RETURNING:
		animate_between_component.animation_finished.connect(_on_returned)
		animate_between_component.start_animation(resident_sprite.global_position, global_position)


func _on_mail_produced() -> void:
	state = States.WAITING


func _on_delivered() -> void:
	state = States.DELIVERED


func _on_returned() -> void:
	if has_mail:
		state = States.WAITING
	else:
		state = States.PRODUCING
