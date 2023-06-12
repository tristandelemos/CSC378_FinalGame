extends Arrow

func _ready() -> void:
	speed = 500
	target = global_position.direction_to(get_global_mouse_position())
	var angle = atan2(-target.x, target.y)
	angle = rad_to_deg(angle)
	# Set the rotation of the arrow's Sprite2D
	$Sprite2D.rotation_degrees = angle + 180
	# Set the rotation of the arrow's CollisionShape2D
	$CollisionShape2D.rotation_degrees = angle


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(3, 4)
	queue_free()
