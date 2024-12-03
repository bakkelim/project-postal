class_name PostOffice
extends StaticBody2D

@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var house_collection_component: HouseCollectionComponent = $HouseCollectionComponent
@onready var coverage_area_component: InteractionComponent = $CoverageAreaComponent
@onready var edges_component: EdgesComponent = $EdgesComponent
@onready var postman: Postman = $Postman


func _ready() -> void:
	coverage_area_component.body_entered.connect(_on_body_entered)
	coverage_area_component.body_exited.connect(_on_body_exited)


func _get_global_positions() -> Array[Vector2]:
	var global_positions: Array[Vector2] = []
	global_positions.append_array(house_collection_component.get_global_positions())
	global_positions.append_array(mailbox_collection_component.get_global_positions())
	return global_positions


func _on_mailbox_grabbed(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)
	edges_component.redraw_edges = true


func _on_mailbox_placed(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)
	edges_component.redraw_edges = false


func _on_body_entered(body: Node2D) -> void:
	if body is House:
		house_collection_component.add(body)
		#edges_component.draw_edges(_get_global_positions())
	elif body is Mailbox:
		mailbox_collection_component.add(body)
		#edges_component.draw_edges(_get_global_positions())
		body.grabbed.connect(_on_mailbox_grabbed.bind(body))
		body.placed.connect(_on_mailbox_placed.bind(body))


func _on_body_exited(body: Node2D) -> void:
	if body is House:
		house_collection_component.remove(body)
		#edges_component.draw_edges(_get_global_positions())
	elif body is Mailbox:
		mailbox_collection_component.remove(body)
		#edges_component.draw_edges(_get_global_positions())
		body.grabbed.disconnect(_on_mailbox_grabbed)
		body.placed.disconnect(_on_mailbox_placed)
