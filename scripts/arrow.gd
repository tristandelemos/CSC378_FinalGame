extends Area2D
class_name Arrow

var target
var speed := 700

func _physics_process(delta: float) -> void:
	global_position += speed * delta * target
	
func _on_timer_timeout() -> void:
	queue_free()
