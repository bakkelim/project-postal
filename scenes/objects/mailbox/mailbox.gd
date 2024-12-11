class_name Mailbox
extends Area2D

signal grabbed
signal placed
signal capacity_changed(is_full: bool)

const Scene: PackedScene = preload("res://scenes/objects/mailbox/mailbox.tscn")

@export var coverage_radius: float = 600.0

var is_full: bool = false
var is_grabbed: bool

@onready var pick_up_component: PickUpComponent = $PickUpComponent
@onready var full_label: Label = $FullLabel
@onready var building_component: BuildingComponent = $BuildingComponent
@onready var _house_collection_component: HouseCollectionComponent = $HouseCollectionComponent
@onready var _edges_component: EdgesComponent = $EdgesComponent
@onready var _capacity_component: CapacityComponent = $CapacityComponent
@onready var _coverage_area_component: Area2D = $CoverageAreaComponent


static func new_instance(mouse_tile_position: Vector2i) -> Mailbox:
	var instance: Mailbox = Scene.instantiate()
	instance.global_position = mouse_tile_position * 64
	return instance


func _ready() -> void:
	_coverage_area_component.area_entered.connect(_on_coverage_area_entered)
	_coverage_area_component.area_exited.connect(_on_coverage_area_exited)
	pick_up_component.grabbed.connect(_on_grabbed)
	pick_up_component.placed.connect(_on_placed)
	full_label.visible = false


func deposit_mail(mail: Mail) -> void:
	_capacity_component.deposit_mail(mail)
	_capacity_changed()


func collect_mail() -> Array[Mail]:
	_capacity_changed.call_deferred()
	return _capacity_component.collect_mail()


func get_center_position() -> Vector2:
	var x := global_position.x + (32 * building_component.dimensions.x)
	var y := global_position.y + (32 * building_component.dimensions.y)
	return Vector2(x, y)


func _draw() -> void:
	if is_grabbed:
		draw_circle(
			to_local(get_center_position()), coverage_radius, Color(0, 0.980392, 0.603922, .1)
		)


func _capacity_changed() -> void:
	is_full = _capacity_component.is_full()
	full_label.visible = is_full
	capacity_changed.emit(is_full)


func _on_grabbed() -> void:
	is_grabbed = true
	queue_redraw()
	_edges_component.redraw_edges = true
	grabbed.emit()


func _on_placed() -> void:
	is_grabbed = false
	queue_redraw()
	_edges_component.redraw_edges = false
	placed.emit()


func _on_coverage_area_entered(area: Area2D) -> void:
	if not area is House:
		return

	_house_collection_component.add(area)
	_edges_component.draw_edges(_house_collection_component.get_global_positions())


func _on_coverage_area_exited(area: Area2D) -> void:
	if not area is House:
		return

	_house_collection_component.remove(area)
	_edges_component.draw_edges(_house_collection_component.get_global_positions())
