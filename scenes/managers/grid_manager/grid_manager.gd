class_name GridManager
extends Node

@export var highlight_tile_map_layer: TileMapLayer
@export var road_manager: RoadManager

var occupied_tiles: Dictionary = {}


func _ready() -> void:
	GameEvents.building_placed.connect(_on_building_placed)


func position_to_grid(position: Vector2) -> Vector2i:
	var grid_position := position / GameState.tile_size
	grid_position = grid_position.floor()
	return grid_position


func are_tiles_available(tiles: Array[Vector2i]) -> bool:
	for t in tiles:
		if not is_tile_available(t):
			return false
	return true


func is_tile_available(poistion: Vector2i) -> bool:
	return not occupied_tiles.has(poistion)


func get_mouse_tile_position() -> Vector2i:
	var mouse_position := highlight_tile_map_layer.get_global_mouse_position()
	return position_to_grid(mouse_position)


func get_random_free_area(size: Vector2i) -> Vector2:
	var viewpost_size := get_viewport().get_visible_rect().size
	var has_valid_position := false
	var random_tile: Vector2i
	var counter := 0
	while not has_valid_position:
		if counter >= 5:
			return Vector2i.ZERO
		var random_x := randi_range(0, viewpost_size.x - (GameState.tile_size * 2))
		var random_y := randi_range(0, viewpost_size.y - (GameState.tile_size * 2))
		var random_position := Vector2i(random_x, random_y)
		random_tile = position_to_grid(random_position)
		var tile_positions := _get_tile_positions(random_tile, size)
		has_valid_position = are_tiles_available(tile_positions)
		counter += 1

	return random_tile


func _get_tile_positions(start_tile: Vector2i, size: Vector2i) -> Array[Vector2i]:
	var tile_area := Rect2i(start_tile, size)
	var tile_positions: Array[Vector2i] = []
	for x in range(tile_area.position.x, tile_area.end.x):
		for y in range(tile_area.position.y, tile_area.end.y):
			tile_positions.push_back(Vector2i(x, y))
	return tile_positions


func _set_area_as_occupied(positions: Array[Vector2i]) -> void:
	for p in positions:
		set_tile_as_occupied(p)
		road_manager.set_occupied_cell(p)


func set_tile_as_occupied(position: Vector2i) -> void:
	occupied_tiles[position] = true


func _on_building_placed(building_component: BuildingComponent) -> void:
	var building_area := building_component.get_building_area()
	_set_area_as_occupied(building_area)
