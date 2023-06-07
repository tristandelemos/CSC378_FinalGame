extends Orb

var damage := 5

func _ready() -> void:
	speed = 300
	target =  global_position.direction_to(
		get_tree()
			.current_scene.get_node("Player")
			.global_position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage)
	queue_free()
