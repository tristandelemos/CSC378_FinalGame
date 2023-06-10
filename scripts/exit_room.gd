extends Room

func _on_exit_area_body_entered(body: Node2D) -> void:
	GameData.level += 1
	get_tree().reload_current_scene()
