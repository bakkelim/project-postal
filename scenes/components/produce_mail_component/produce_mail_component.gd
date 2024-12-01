class_name ProduceMailComponent
extends Node

signal mail_produced(mail: Mail)

@export var min_produce_time: float = 0.5
@export var max_produce_time: float = 2.0
@export var progress_bar: ProgressBar

@onready var produce_timer: Timer = $ProduceMailTimer


func _ready() -> void:
	produce_timer.timeout.connect(_on_produce_timeout)
	produce_timer.one_shot = true
	await owner.ready
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
	var recipiant_house: House = _pick_random_recipient()
	var mail := Mail.new_instance(recipiant_house)
	mail_produced.emit(mail)


func _pick_random_recipient() -> House:
	var houses := get_tree().get_nodes_in_group("houses")
	var home_index := houses.find(owner.home)
	if home_index >= 0:
		houses.remove_at(home_index)
	return houses.pick_random()
