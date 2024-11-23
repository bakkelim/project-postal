class_name SendMailComponent
extends Node

signal mail_sent

@export var time_to_mail_box: float = 1.0

@onready var send_mail_timer: Timer = $SendMailTimer


func _ready() -> void:
	send_mail_timer.timeout.connect(_on_timeout)
	send_mail_timer.one_shot = true
	#progress_bar.value = 0


#func _physics_process(_delta: float) -> void:
#if produce_timer.is_stopped():
#return
#progress_bar.value = produce_timer.wait_time - produce_timer.time_left


func send_mail() -> void:
	if not send_mail_timer.is_stopped():
		return

	#progress_bar.max_value = wait_time
	#progress_bar.value = 0

	send_mail_timer.wait_time = time_to_mail_box
	send_mail_timer.start()


func _on_timeout() -> void:
	#progress_bar.value = 100
	mail_sent.emit()
