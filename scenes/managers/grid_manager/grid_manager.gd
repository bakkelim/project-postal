class_name GridManager
extends Node

enum Type { DEFAULT, ROAD }

@export var highlight_tile_map_layer: TileMapLayer
@export var road_manager: RoadManager

var occupied_cells: Dictionary = {}


func _ready() -> void:
	GameEvents.building_placed.connect(_on_building_placed)


func position_to_grid(position: Vector2) -> Vector2i:
	var grid_position := position / GameState.tile_size
	grid_position = grid_position.floor()
	return grid_position


func are_cells_available(cells: Array[Vector2i]) -> bool:
	for c in cells:
		if not _is_cell_available(c):
			return false
	return true


func is_road_cell(position: Vector2i) -> bool:
	var cell = occupied_cells.get(position)
	if not cell:
		return false
	if not cell is Type:
		return false
	return cell == Type.ROAD


func get_mouse_cell_position() -> Vector2i:
	var mouse_position := highlight_tile_map_layer.get_global_mouse_position()
	return position_to_grid(mouse_position)


func get_random_free_area(size: Vector2i) -> Vector2:
	var viewpost_size := get_viewport().get_visible_rect().size
	var has_valid_position := false
	var random_cell: Vector2i
	var counter := 0
	while not has_valid_position:
		if counter >= 5:
			return Vector2i.ZERO
		var random_x := randi_range(0, int(viewpost_size.x) - (GameState.tile_size * 2))
		var random_y := randi_range(0, int(viewpost_size.y) - (GameState.tile_size * 2))
		var random_position := Vector2i(random_x, random_y)
		random_cell = position_to_grid(random_position)
		var cell_positions := _get_tile_positions(random_cell, size)
		has_valid_position = are_cells_available(cell_positions)
		counter += 1

	return random_cell


func set_cell_as_occupied(position: Vector2i, type: Type) -> void:
	occupied_cells[position] = type


func _is_cell_available(position: Vector2i) -> bool:
	return not occupied_cells.has(position)


func _get_tile_positions(start_tile: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var tile_area := Rect2i(start_tile, size)
	var tile_positions: Array[Vector2i] = []
	for x in range(tile_area.position.x, tile_area.end.x):
		for y in range(tile_area.position.y, tile_area.end.y):
			tile_positions.push_back(Vector2i(x, y))
	return tile_positions


func _set_area_as_occupied(positions: Array[Vector2i]) -> void:
	for p in positions:
		set_cell_as_occupied(p, Type.DEFAULT)
		road_manager.set_occupied_cell(p)


func _on_building_placed(building_component: BuildingComponent) -> void:
	var building_area := building_component.get_building_area()
	_set_area_as_occupied(building_area)
