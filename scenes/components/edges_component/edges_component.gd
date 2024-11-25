class_name EdgesComponent
extends Node2D

var is_grabbed: bool
var houses: Array[House] = []


func _process(_delta: float) -> void:
	if not is_grabbed:
		return

	draw_lines()


func _draw() -> void:
	for house in houses:
		draw_line(Vector2.ZERO, to_local(house.global_position), Color.WHITE, 8.0)


func draw_lines() -> void:
	queue_redraw()


func draw_houses(p_houses: Array[House]) -> void:
	houses = p_houses
	draw_lines()
