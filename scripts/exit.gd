extends Area2D

@export var next_scene: String

func _on_body_entered(body: Node2D) -> void:
    get_tree().change_scene_to_file(next_scene)
