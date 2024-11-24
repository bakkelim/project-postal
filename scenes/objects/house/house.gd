class_name House
extends StaticBody2D

var connected_to_mailbox: bool

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent
@onready var send_mail_component: SendMailComponent = $SendMailComponent
@onready var mailbox_collection_component: MailCollectionComponent = $MailboxCollectionComponent
@onready var connected_label: Label = $ConnectedLabel


func _ready() -> void:
	send_mail_component.mail_sent.connect(_on_mail_sent)
	produce_mail_component.mail_produced.connect(_on_mail_produced)
	produce_mail_component.produce_mail()


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	_set_connected_to_mailbox()
	_set_connected_label()


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	_set_connected_to_mailbox()
	_set_connected_label()


func _set_connected_to_mailbox() -> void:
	connected_to_mailbox = mailbox_collection_component.count()


func _set_connected_label() -> void:
	if connected_to_mailbox:
		connected_label.text = "V"
	else:
		connected_label.text = "X"


func _on_mail_produced() -> void:
	print("mail_produced")
	if not connected_to_mailbox:
		return
	send_mail_component.send_mail()


func _on_mail_sent() -> void:
	print("mail_sent")
	produce_mail_component.produce_mail()
