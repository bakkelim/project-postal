class_name BuildingComponent
extends Node2D


func _ready() -> void:
	GameEvents.building_placed.emit(self)


func get_tile_position() -> Vector2i:
	var grid_position := global_position / 64
	grid_position = grid_position.floor()
	return grid_position
