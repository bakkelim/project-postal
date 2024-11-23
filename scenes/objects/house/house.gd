class_name House
extends StaticBody2D

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent
@onready var send_mail_component: SendMailComponent = $SendMailComponent
@onready var mailbox_collection_component: MailCollectionComponent = $MailboxCollectionComponent


func _ready() -> void:
	send_mail_component.mail_sent.connect(_on_mail_sent)
	produce_mail_component.mail_produced.connect(_on_mail_produced)
	produce_mail_component.produce_mail()


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)


#func _find_mail_box() -> String:
#if mail_boxes.count() == 0:
#return null
#
#for box in mail_boxes:
#return box


func _on_mail_produced() -> void:
	print("mail_produced")
	#var mail_box := _find_mail_box()
	#if not mail_box:
	#print("mail_produced")
	#return
	#send_mail_component.send_mail()


func _on_mail_sent() -> void:
	print("mail_sent")
	produce_mail_component.produce_mail()
