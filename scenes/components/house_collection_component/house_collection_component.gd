class_name HouseCollectionComponent
extends Node

var collection: Array[House] = []


func add(house: House) -> void:
	if collection.has(house):
		return
	collection.push_back(house)


func remove(house: House) -> void:
	collection.erase(house)
