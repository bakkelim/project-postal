class_name BuildingComponent
extends Node2D

@export var dimensions: Vector2i = Vector2i.ONE


func _ready() -> void:
	GameEvents.building_placed.emit(self)


func get_building_area() -> Array[Vector2i]:
	var tile_position := _get_tile_position()
	return _get_tile_positions(tile_position)


func _get_tile_position() -> Vector2i:
	var grid_position := global_position / 64
	grid_position = grid_position.floor()
	return grid_position


func _get_tile_positions(start_position: Vector2i) -> Array[Vector2i]:
	var tile_area := Rect2i(start_position, dimensions)
	var tile_positions: Array[Vector2i] = []
	for x in range(tile_area.position.x, tile_area.end.x):
		for y in range(tile_area.position.y, tile_area.end.y):
			tile_positions.push_back(Vector2i(x, y))
	return tile_positions
