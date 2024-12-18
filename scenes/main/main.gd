class_name Main
extends Node

@onready var road_manager: RoadManager = $RoadManager


func _ready() -> void:
	road_manager.get_path_between(Vector2i(0,0), Vector2i(0,4))
