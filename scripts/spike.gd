extends Node2D

@onready var anim_player = $AnimationPlayer

@export var damage: int = 3

func _on_detector_body_entered(body: Node2D) -> void:
	if not anim_player.is_playing():
		anim_player.play("start")

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
