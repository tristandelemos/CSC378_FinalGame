extends Area2D
class_name Orb

var target
var speed := 500

func _physics_process(delta: float) -> void:
	global_position += speed * delta * target

func _on_timer_timeout() -> void:
	queue_free()
