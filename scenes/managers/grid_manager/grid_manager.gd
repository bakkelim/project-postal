class_name GridManager
extends Node

@export var highlight_tile_map_layer: TileMapLayer

var occupied_tiles: Dictionary = {}


func _ready() -> void:
	GameEvents.building_placed.connect(_on_building_placed)


func is_tile_available(poistion: Vector2i) -> bool:
	return not occupied_tiles.has(poistion)


func set_tile_as_occupied(position: Vector2i) -> void:
	occupied_tiles[position] = true


func get_mouse_tile_position() -> Vector2i:
	var mouse_position := highlight_tile_map_layer.get_global_mouse_position()
	var grid_position := mouse_position / 64
	grid_position = grid_position.floor()
	return grid_position


func _on_building_placed(building_component: BuildingComponent) -> void:
	var position := building_component.get_tile_position()
	set_tile_as_occupied(position)
