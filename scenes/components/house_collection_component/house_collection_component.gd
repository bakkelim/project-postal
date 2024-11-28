class_name HouseCollectionComponent
extends Node

var _collection: Array[House] = []


func get_collection() -> Array[House]:
	return _collection


func add(house: House) -> void:
	if _collection.has(house):
		return
	_collection.push_back(house)


func remove(house: House) -> void:
	_collection.erase(house)


func get_global_positions() -> Array[Vector2]:
	var global_positions: Array[Vector2] = []
	for c in _collection:
		global_positions.push_back(c.global_position)
	return global_positions
