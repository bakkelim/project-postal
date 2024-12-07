class_name SpawnManager
extends Node

signal spawn_timeout

@export var min_spawn_time: float = 4
@export var max_spawn_time: float = 10
@export var house_root: Node

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
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


func _on_spawn_timeout() -> void:
	spawn_timeout.emit()
	if house_root.get_child_count() > 10:
		return
	_start_timer()
