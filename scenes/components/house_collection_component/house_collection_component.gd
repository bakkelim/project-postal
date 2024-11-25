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
