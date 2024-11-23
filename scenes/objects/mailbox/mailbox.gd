class_name Mailbox
extends StaticBody2D

@onready var coverage_area_component: InteractionComponent = $CoverageAreaComponent
@onready var house_collection_component: HouseCollectionComponent = $HouseCollectionComponent


func _ready() -> void:
	coverage_area_component.body_entered.connect(_on_body_entered)
	coverage_area_component.body_exited.connect(_on_body_exited)


#func _draw() -> void:
#draw_circle(Vector2(0, 0), radius, Color(0, 0.980392, 0.603922, .1))


func _on_body_entered(body: Node2D) -> void:
	if not body is House:
		return
	house_collection_component.add(body)
	(body as House).register_mailbox(self)


func _on_body_exited(body: Node2D) -> void:
	if not body is House:
		return
	house_collection_component.remove(body)
	(body as House).unregister_mailbox(self)
