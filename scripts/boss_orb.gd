extends Orb

var damage := 5

func _physics_process(delta: float) -> void:
	global_position += speed * delta * target

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
	queue_free()
