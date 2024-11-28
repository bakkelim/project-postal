class_name EdgesComponent
extends Node2D

var redraw_edges: bool
var _edges: Array[Vector2] = []


func _process(_delta: float) -> void:
	if not redraw_edges:
		return
	queue_redraw()


func _draw() -> void:
	for edge in _edges:
		draw_line(Vector2.ZERO, to_local(edge), Color(0, 0, 0, .5), 2.0)


func draw_edges(edges: Array[Vector2]) -> void:
	_edges = edges
	queue_redraw()
