class_name EdgesComponent
extends Node2D

var redraw_edges: bool
var houses: Array[House] = []


func _process(_delta: float) -> void:
	if not redraw_edges:
		return

	queue_redraw()


func _draw() -> void:
	for house in houses:
		draw_line(Vector2.ZERO, to_local(house.global_position), Color.WHITE, 8.0)


func draw_edges(p_houses: Array[House]) -> void:
	houses = p_houses
	queue_redraw()
