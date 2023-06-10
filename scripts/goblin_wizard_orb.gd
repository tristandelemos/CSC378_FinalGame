extends Orb

var damage := 5

func _ready() -> void:
	speed = 300
	target =  global_position.direction_to(
		get_tree()
			.current_scene.get_node("Player")
			.global_position)


func _on_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
	queue_free()
