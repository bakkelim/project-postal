class_name Mail
extends RefCounted

var recipient: House


static func new_instance(house: House) -> Mail:
	var instance: Mail = Mail.new()
	instance.recipient = house
	return instance
