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
@onready var _building_component: BuildingComponent = $BuildingComponent
@onready var mailbox_detection_area: Area2D = $MailboxDetectionArea
@onready var _sprite: Sprite2D = $Sprite2D


static func new_instance(tile_position: Vector2i) -> House:
	var instance: House = Scene.instantiate()
	instance.global_position = tile_position * GameState.tile_size
	return instance


func _init() -> void:
	house_counter += 1
	id = "House%s" % [house_counter]


func _ready() -> void:
	var sprite_size := _sprite.texture.get_size()
	_sprite.scale = Vector2(GameState.tile_size / sprite_size.x, GameState.tile_size / sprite_size.y)
	mailbox_detection_area.area_entered.connect(_on_mailbox_detection_area_entered)
	mailbox_detection_area.area_exited.connect(_on_mailbox_detection_area_exited)


func register_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	connected_label.visible = not mailbox_collection_component.has_available_mailbox()


func unregister_mailbox(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	connected_label.visible = not mailbox_collection_component.has_available_mailbox()


func get_center_position() -> Vector2:
	var x := global_position.x + ((GameState.tile_size / 2) * _building_component.dimensions.x)
	var y := global_position.y + ((GameState.tile_size / 2) * _building_component.dimensions.y)
	return Vector2(x, y)


func _on_mailbox_detection_area_entered(area: Area2D) -> void:
	if area.owner is Mailbox:
		var mailbox: Mailbox = area.owner
		register_mailbox(mailbox)


func _on_mailbox_detection_area_exited(area: Area2D) -> void:
	if area.owner is Mailbox:
		var mailbox: Mailbox = area.owner
		unregister_mailbox(mailbox)
