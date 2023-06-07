extends Collectible

@onready var direction := Vector2(RngUtils.float_range(-1, 1), RngUtils.float_range(-1, 1))
@onready var anim_player := $AnimationPlayer
var spread := true

func _process(delta: float) -> void:
	if spread:
		global_position += 2 * direction

func _on_body_entered(body: Node2D) -> void:
	GameData.curr_coins += 1
	SignalBus.coin_collected.emit()
	anim_player.play("pickup")

func _on_spread_timer_timeout() -> void:
	spread = false
