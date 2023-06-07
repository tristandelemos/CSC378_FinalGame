extends Room

func _on_exit_area_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
