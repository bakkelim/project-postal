class_name Mailbox
extends StaticBody2D

@export var coverage_radius: float = 600.0

@onready var coverage_area_component: InteractionComponent = $CoverageAreaComponent
@onready var house_collection_component: HouseCollectionComponent = $HouseCollectionComponent
@onready
var hover_house_collection_component: HouseCollectionComponent = $HoverHouseCollectionComponent
@onready var pick_up_component: PickUpComponent = $PickUpComponent
@onready var edges_component: EdgesComponent = $EdgesComponent
@onready var hover_area_component: InteractionComponent = $HoverAreaComponent


func _ready() -> void:
	coverage_area_component.body_entered.connect(_on_body_entered)
	coverage_area_component.body_exited.connect(_on_body_exited)
	hover_area_component.body_entered.connect(_on_hover_entered)
	hover_area_component.body_exited.connect(_on_hover_exited)
	pick_up_component.grabbed.connect(_on_grabbed)
	pick_up_component.placed.connect(_on_placed)


func _draw() -> void:
	draw_circle(Vector2(0, 0), coverage_radius, Color(0, 0.980392, 0.603922, .1))


func _on_grabbed() -> void:
	coverage_area_component.monitoring = false
	hover_area_component.monitoring = true
	edges_component.is_grabbed = true


func _on_placed() -> void:
	coverage_area_component.monitoring = true
	hover_area_component.monitoring = false
	edges_component.is_grabbed = false


func _on_body_entered(body: Node2D) -> void:
	if not body is House:
		return
	house_collection_component.add(body)
	(body as House).register_mailbox(self)
	edges_component.draw_houses(house_collection_component.get_collection())


func _on_body_exited(body: Node2D) -> void:
	if not body is House:
		return
	house_collection_component.remove(body)
	(body as House).unregister_mailbox(self)
	edges_component.draw_houses(house_collection_component.get_collection())


func _on_hover_entered(body: Node2D) -> void:
	if not body is House:
		return
	hover_house_collection_component.add(body)
	edges_component.draw_houses(hover_house_collection_component.get_collection())


func _on_hover_exited(body: Node2D) -> void:
	if not body is House:
		return
	hover_house_collection_component.remove(body)
	edges_component.draw_houses(hover_house_collection_component.get_collection())
