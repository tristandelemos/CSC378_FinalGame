extends Orb

func _ready() -> void:
	speed = 500
	target = global_position.direction_to(get_global_mouse_position())

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(3)
	queue_free()
