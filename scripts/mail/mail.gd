class_name Mail
extends RefCounted

var recipient_house_id: String
var recipient_house_position: Vector2


static func new_instance(house: House) -> Mail:
	var instance: Mail = Mail.new()
	instance.recipient_house_id = house.id
	instance.recipient_house_position = house.global_position
	return instance
