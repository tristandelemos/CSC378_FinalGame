extends Enemy

@onready var anim_player = $AnimationPlayer
@onready var orb = preload("res://instances/goblin_wizard_orb.tscn")

var knocback_val = 200
var spawn_points

func _ready() -> void:
	super._ready()
	anim_player.play("appear")

func _physics_process(delta: float) -> void:
	direction = global_position.direction_to(player.global_position)
	if is_knocked_back:
		direction *= -1
		velocity = direction * knocback_val
	else:
		velocity = Vector2(0, 0)
	move_and_slide()

func change_position():
	var chosen_pos = RngUtils.array(spawn_points)[0]
	global_position = chosen_pos.global_position

func _on_attack_cooldown_timeout() -> void:
	anim_player.play("attack")

func _on_teleport_timer_timeout() -> void:
	anim_player.play("appear")

func _on_orb_cooldown_timer_timeout() -> void:
	$AttackAudio.play()
	var orb_instance = orb.instantiate()
	orb_instance.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", orb_instance)
