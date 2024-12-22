class_name RoadManager
extends Node

@export var grid_manager: GridManager
@export var road_tile_map_layer: TileMapLayer
@export var post_office: PostOffice

var _astargrid: AStarGrid2D


func _ready() -> void:
	var x: int = floor(1152.0 / GameState.tile_size)
	var y: int = floor(648.0 / GameState.tile_size)
	_astargrid = AStarGrid2D.new()
	_astargrid.region = Rect2i(Vector2i.ZERO, Vector2i(x, y))
	_astargrid.cell_size = Vector2i(GameState.tile_size, GameState.tile_size)
	_astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astargrid.jumping_enabled = false
	_astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.update()


func set_occupied_cell(position: Vector2i) -> void:
	_astargrid.set_point_solid(position, true)


func set_free_cell(position: Vector2i) -> void:
	_astargrid.set_point_solid(position, false)


func create_road(from: House) -> void:
	var from_cell: Vector2i = grid_manager.position_to_grid(from.global_position)

	var path := _find_shortest_path(from_cell)
	for c in path:
		road_tile_map_layer.set_cell(c, 0, Vector2i.ZERO)
		grid_manager.set_cell_as_occupied(c, GridManager.Type.ROAD)


func _get_path_between(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var etst := _astargrid.get_id_path(from, to)
	return etst


func _sort_by_distance_to_destination(
	cell1: Vector2i, cell2: Vector2i, destination: Vector2i
) -> bool:
	var distance_to_cell1 := destination.distance_to(cell1)
	var distance_to_cell2 := destination.distance_to(cell2)
	return distance_to_cell1 < distance_to_cell2


func _find_shortest_path(from_cell: Vector2i) -> Array[Vector2i]:
	set_free_cell(from_cell)
	var shortest_path: Array[Vector2i]
	if road_tile_map_layer.get_used_cells().size() <= 0:
		shortest_path = _get_path_to_post_office(from_cell)
	else:
		shortest_path = _get_path_to_closest_road_cell(from_cell)

	shortest_path.pop_back()
	shortest_path.pop_front()
	set_occupied_cell(from_cell)
	return shortest_path


func _get_path_to_closest_road_cell(from_cell: Vector2i) -> Array[Vector2i]:
	var road_cells := road_tile_map_layer.get_used_cells()
	var first_road_cell: Vector2i = road_cells.pop_back()
	var shortest_path: Array[Vector2i] = _astargrid.get_id_path(from_cell, first_road_cell)
	for cell in road_cells:
		var temp_path := _astargrid.get_id_path(from_cell, cell)
		if temp_path.size() < shortest_path.size():
			shortest_path = temp_path
	return shortest_path


func _get_path_to_post_office(from_cell: Vector2i) -> Array[Vector2i]:
	var post_office_grids := post_office.get_building_cells()
	post_office_grids.sort_custom(_sort_by_distance_to_destination.bind(from_cell))
	var post_office_cell := post_office_grids[0]
	set_free_cell(post_office_cell)
	var shortest_path := _astargrid.get_id_path(from_cell, post_office_cell)
	set_occupied_cell(post_office_cell)
	return shortest_path
