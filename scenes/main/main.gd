class_name Main
extends Node

@onready var road_manager: RoadManager = $RoadManager


func _ready() -> void:
	pass
	#print(road_manager.get_path_between(Vector2i(5, 2), Vector2i(14, 2)))
