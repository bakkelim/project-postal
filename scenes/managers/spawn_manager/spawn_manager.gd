class_name SpawnManager
extends Node

@export var min_spawn_time: float = 4
@export var max_spawn_time: float = 10
@export var house_root: Node
@export var enabled: bool = true
@export var grid_manager: GridManager

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	if not enabled:
		return
	spawn_timer.timeout.connect(_on_spawn_timeout)
	spawn_timer.one_shot = true
	spawn_timer.autostart = false
	_start_timer()


func _start_timer() -> void:
	if not spawn_timer.is_stopped():
		return

	var wait_time = _get_wait_time()

	spawn_timer.wait_time = wait_time
	spawn_timer.start()


func _get_wait_time() -> float:
	return randf_range(min_spawn_time, max_spawn_time)


func _spawn_house_at_random_position() -> void:
	var start_tile := grid_manager.get_random_free_area(Vector2i(2, 2))
	if start_tile == Vector2.ZERO:
		return
	var instance := House.new_instance(start_tile)
	house_root.add_child(instance)


func _on_spawn_timeout() -> void:
	if house_root.get_child_count() > 10:
		return
	_spawn_house_at_random_position()
	_start_timer()
