class_name PostOffice
extends Area2D

@onready var mailbox_collection_component: MailboxCollectionComponent = $MailboxCollectionComponent
@onready var house_collection_component: HouseCollectionComponent = $HouseCollectionComponent
@onready var coverage_area_component: InteractionComponent = $CoverageAreaComponent
@onready var postman: Postman = $Postman
@onready var _building_component: BuildingComponent = $BuildingComponent
@onready var _sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	var sprite_size := _sprite.texture.get_size()
	_sprite.scale = Vector2(
		(GameState.tile_size / sprite_size.x) * _building_component.dimensions.x, 
		(GameState.tile_size / sprite_size.y) * _building_component.dimensions.y
		)
	
	coverage_area_component.area_entered.connect(_on_coverage_area_entered)
	coverage_area_component.area_exited.connect(_on_coverage_area_exited)


func get_center_position() -> Vector2:
	var x := global_position.x + ((GameState.tile_size / 2) * _building_component.dimensions.x)
	var y := global_position.y + ((GameState.tile_size / 2) * _building_component.dimensions.y)
	return Vector2(x, y)


func _get_global_positions() -> Array[Vector2]:
	var global_positions: Array[Vector2] = []
	global_positions.append_array(house_collection_component.get_global_positions())
	global_positions.append_array(mailbox_collection_component.get_global_positions())
	return global_positions


func _on_mailbox_grabbed(mailbox: Mailbox) -> void:
	mailbox_collection_component.remove(mailbox)


func _on_mailbox_placed(mailbox: Mailbox) -> void:
	mailbox_collection_component.add(mailbox)


func _on_coverage_area_entered(area: Area2D) -> void:
	if area is House:
		house_collection_component.add(area)
	elif area is Mailbox:
		mailbox_collection_component.add(area)
		area.grabbed.connect(_on_mailbox_grabbed.bind(area))
		area.placed.connect(_on_mailbox_placed.bind(area))


func _on_coverage_area_exited(area: Area2D) -> void:
	if area is House:
		house_collection_component.remove(area)
	elif area is Mailbox:
		mailbox_collection_component.remove(area)
		area.grabbed.disconnect(_on_mailbox_grabbed)
		area.placed.disconnect(_on_mailbox_placed)
