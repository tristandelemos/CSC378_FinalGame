extends StaticBody2D
class_name Breakable

@onready var heart = preload("res://instances/heart.tscn")
@onready var coin = preload("res://instances/coin.tscn")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	var roll = RngUtils.int_range(0, 100)
	if roll < 5:
		var heart_instance = heart.instantiate()
		heart_instance.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", heart_instance)
	elif roll < 50:
		for i in range(RngUtils.int_range(1, 5)):
			var coin_instance = coin.instantiate()
			coin_instance.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", coin_instance)
	$AnimationPlayer.play("break")
