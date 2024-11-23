class_name House
extends Node2D

@onready var produce_mail_component: ProduceMailComponent = $ProduceMailComponent


func _ready() -> void:
	produce_mail_component.mail_produced.connect(_on_mail_produced)
	produce_mail_component.produce_mail()


func _on_mail_produced() -> void:
	produce_mail_component.produce_mail()
