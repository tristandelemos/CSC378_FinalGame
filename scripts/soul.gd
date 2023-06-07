extends Collectible
@onready var anim_player := $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	GameData.curr_souls += 1
	SignalBus.soul_collected.emit()
	anim_player.play("pickup")
