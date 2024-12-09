class_name House
extends Area2D

const Scene: PackedScene = preload("res://scenes/objects/house/house.tscn")

static var house_counter := 0

var id: String
var received_mail_count: int = 0:
	set(value):
		received_mail_count = value
		received_mails_label.text = str(received_mail_count)

@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var connected_label: Label = $ConnectedLabel
@onready var received_mails_label: Label = $ReceivedMailsLabel
@onready var building_component: BuildingComponent = $BuildingComponent


static func new_instance(mouse_tile_position: Vector2i) -> House:
	var instance: House = Scene.instantiate()
	instance.global_position = mouse_tile_position * 64
	return instance


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


func get_center_position() -> Vector2:
	var x := global_position.x + (32 * building_component.dimensions.x)
	var y := global_position.y + (32 * building_component.dimensions.y)
	return Vector2(x, y)
