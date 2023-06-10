extends Area2D

var heal_amount = 20

func _on_body_entered(body: Node2D) -> void:
	if GameData.curr_player_health < GameData.base_player_health:
		GameData.curr_player_health += heal_amount
		if GameData.curr_player_health > GameData.base_player_health:
			GameData.curr_player_health = GameData.base_player_health
		SignalBus.health_pickup.emit()
		$AnimationPlayer.play("pickup")


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("disappear")
