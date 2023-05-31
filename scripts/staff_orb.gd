extends Area2D

var speed := 500
var target

func _ready() -> void:
    target = global_position.direction_to(get_global_mouse_position())

func _physics_process(delta: float) -> void:
    global_position += speed * delta * target

func _on_timer_timeout() -> void:
    queue_free()

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("Enemy"):
        body.take_damage(3, 4)
    queue_free()
