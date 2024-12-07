class_name Mailbox
extends StaticBody2D

signal grabbed
signal placed
signal full

const Scene: PackedScene = preload("res://scenes/objects/mailbox/mailbox.tscn")

@export var coverage_radius: float = 600.0
@export var capacity: int = 5

var is_full: bool = false
var is_grabbed: bool

@onready var coverage_area_component: InteractionComponent = $CoverageAreaComponent
@onready var house_collection_component: HouseCollectionComponent = $HouseCollectionComponent
@onready
var hover_house_collection_component: HouseCollectionComponent = $HoverHouseCollectionComponent
@onready var pick_up_component: PickUpComponent = $PickUpComponent
@onready var edges_component: EdgesComponent = $EdgesComponent
@onready var hover_area_component: InteractionComponent = $HoverAreaComponent
@onready var capacity_component: CapacityComponent = $CapacityComponent
@onready var full_label: Label = $FullLabel
@onready var building_component: BuildingComponent = $BuildingComponent


static func new_instance(mouse_tile_position: Vector2i) -> Mailbox:
	var instance: Mailbox = Scene.instantiate()
	instance.global_position = mouse_tile_position * 64
	return instance


func _ready() -> void:
	coverage_area_component.body_entered.connect(_on_body_entered)
	coverage_area_component.body_exited.connect(_on_body_exited)
	hover_area_component.body_entered.connect(_on_hover_entered)
	hover_area_component.body_exited.connect(_on_hover_exited)
	pick_up_component.grabbed.connect(_on_grabbed)
	pick_up_component.placed.connect(_on_placed)
	capacity_component.changed.connect(_on_capacity_changed)
	capacity_component.capacity = capacity
	full_label.visible = false


func deliver_mail(mail: Mail) -> void:
	capacity_component.deposit_mail(mail)


func get_center_position() -> Vector2:
	var x := global_position.x + (32 * building_component.dimensions.x)
	var y := global_position.y + (32 * building_component.dimensions.y)
	return Vector2(x, y)


func _draw() -> void:
	if is_grabbed:
		draw_circle(Vector2(0, 0), coverage_radius, Color(0, 0.980392, 0.603922, .1))


func _on_grabbed() -> void:
	is_grabbed = true
	queue_redraw()
	coverage_area_component.monitoring = false
	hover_area_component.monitoring = true
	edges_component.redraw_edges = true
	grabbed.emit()


func _on_placed() -> void:
	is_grabbed = false
	queue_redraw()
	if not is_full:
		coverage_area_component.monitoring = true
	hover_area_component.monitoring = false
	edges_component.redraw_edges = false
	placed.emit()


func _on_body_entered(body: Node2D) -> void:
	if body is House:
		house_collection_component.add(body)
		(body as House).register_mailbox(self)
		edges_component.draw_edges(house_collection_component.get_global_positions())
	elif body is PostOffice:
		(body as PostOffice).mailbox_collection_component.add(self)


func _on_body_exited(body: Node2D) -> void:
	if body is House:
		house_collection_component.remove(body)
		(body as House).unregister_mailbox(self)
		edges_component.draw_edges(house_collection_component.get_global_positions())
	elif body is PostOffice:
		(body as PostOffice).mailbox_collection_component.remove(self)


func _on_hover_entered(body: Node2D) -> void:
	if not body is House:
		return
	hover_house_collection_component.add(body)
	edges_component.draw_edges(hover_house_collection_component.get_global_positions())


func _on_hover_exited(body: Node2D) -> void:
	if not body is House:
		return
	hover_house_collection_component.remove(body)
	edges_component.draw_edges(hover_house_collection_component.get_global_positions())


func _on_capacity_changed() -> void:
	if capacity_component.is_full():
		_update_mailbox_full()
	else:
		_update_mailbox_not_full()


func _update_mailbox_not_full() -> void:
	coverage_area_component.monitoring = true
	is_full = false
	full_label.visible = false


func _update_mailbox_full() -> void:
	coverage_area_component.monitoring = false
	is_full = true
	full_label.visible = true
	full.emit()
