class_name ProduceMailComponent
extends Node2D

signal mail_produced

@export var min_produce_time: float = 0.5
@export var max_produce_time: float = 2.0

@onready var produce_timer: Timer = $ProduceTimer
@onready var progress_bar: ProgressBar = $ProgressBar


func _ready() -> void:
	produce_timer.timeout.connect(_on_produce_timeout)
	produce_timer.one_shot = true
	progress_bar.value = 0


func _physics_process(_delta: float) -> void:
	if produce_timer.is_stopped():
		return
	progress_bar.value = produce_timer.wait_time - produce_timer.time_left


func produce_mail() -> void:
	if not produce_timer.is_stopped():
		return

	var wait_time = _get_wait_time()

	progress_bar.max_value = wait_time
	progress_bar.value = 0

	produce_timer.wait_time = wait_time
	produce_timer.start()


func _get_wait_time() -> float:
	return randf_range(min_produce_time, max_produce_time)


func _on_produce_timeout() -> void:
	progress_bar.value = 100
	mail_produced.emit()
