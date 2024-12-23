class_name RoadPathManager
extends Node

var _astargrid: AStarGrid2D


func _ready() -> void:
	var x: int = floor(1152.0 / GameState.tile_size)
	var y: int = floor(648.0 / GameState.tile_size)
	var region := Rect2i(Vector2i.ZERO, Vector2i(x, y))
	_astargrid = AStarGrid2D.new()
	_astargrid.region = region
	_astargrid.cell_size = Vector2i(GameState.tile_size, GameState.tile_size)
	_astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astargrid.jumping_enabled = false
	_astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astargrid.update()
	_astargrid.fill_solid_region(region)


func get_resident_walking_to_house_path(resident: Resident) -> Array[Vector2i]:
	var resident_cell := GridManager.position_to_cell(resident.global_position)
	var house_cell := GridManager.position_to_cell(resident.home.global_position)

	var path := _astargrid.get_id_path(resident_cell, resident.home.road_cell)
	path.append(house_cell)
	return path


func get_resident_walking_to_mailbox_path(resident: Resident, mailbox: Mailbox) -> Array[Vector2i]:
	var mailbox_cell := GridManager.position_to_cell(mailbox.global_position)
	return _astargrid.get_id_path(resident.home.road_cell, mailbox_cell)


func get_postman_walking_to_mailbox_path(postman: Postman, mailbox: Mailbox) -> Array[Vector2i]:
	var post_office_cell := GridManager.position_to_cell(postman.working_place.global_position)
	var postman_cell := GridManager.position_to_cell(postman.global_position)
	var mailbox_cell := GridManager.position_to_cell(mailbox.global_position)

	if postman_cell == post_office_cell:
		postman_cell = postman.working_place.road_cell

	return _astargrid.get_id_path(postman_cell, mailbox_cell)


func get_postman_walking_to_post_office_path(postman: Postman) -> Array[Vector2i]:
	var post_office_cell := GridManager.position_to_cell(postman.working_place.global_position)
	var postman_cell := GridManager.position_to_cell(postman.global_position)

	var path := _astargrid.get_id_path(postman_cell, postman.working_place.road_cell)
	path.append(post_office_cell)
	return path


func get_postman_walking_to_house_path(
	postman: Postman, house: House, previous_house: House
) -> Array[Vector2i]:
	var post_office_cell := GridManager.position_to_cell(postman.working_place.global_position)
	var house_cell := GridManager.position_to_cell(house.global_position)
	var postman_cell := GridManager.position_to_cell(postman.global_position)
	if postman_cell == house_cell:
		return []

	if postman_cell == post_office_cell:
		postman_cell = postman.working_place.road_cell
	elif previous_house:
		var previous_house_cell := GridManager.position_to_cell(previous_house.global_position)
		if postman_cell == previous_house_cell:
			postman_cell = previous_house.road_cell

	var path := _astargrid.get_id_path(postman_cell, house.road_cell)
	path.append(house_cell)
	return path


func set_free_cell(position: Vector2i) -> void:
	_astargrid.set_point_solid(position, false)
