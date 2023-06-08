extends Area2D

var heal_amount = 5

func _on_body_entered(body: Node2D) -> void:
	GameData.curr_player_health += heal_amount
	SignalBus.health_pickup.emit()
	queue_free()
