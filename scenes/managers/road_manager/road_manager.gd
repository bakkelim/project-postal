class_name RoadManager
extends Node

var _astargrid: AStarGrid2D


func _ready() -> void:
	_astargrid = AStarGrid2D.new()
	_astargrid.size = Vector2i(1152 / GameState.tile_size, 648 / GameState.tile_size)
	_astargrid.cell_size = Vector2i(GameState.tile_size,GameState.tile_size)
	_astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astargrid.jumping_enabled = false
	_astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.update()


func set_occupied_cell(position: Vector2i) -> void:
	_astargrid.set_point_solid(position, true)


func set_free_cell(position: Vector2i) -> void:
	_astargrid.set_point_solid(position, false)


func get_path_between(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	return _astargrid.get_id_path(from, to)
