extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var orb = preload("res://instances/staff_orb.tscn")

var can_fire := true
var lock_swipe_rotation := false

func _process(delta: float) -> void:
	if not lock_swipe_rotation:
		look_at(get_global_mouse_position())
	if Input.is_action_pressed("attack"):
		ranged_attack()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		melee_attack()

func melee_attack():
	match(GameData.curr_player_weapon):
		GameData.Weapon.DAGGER:
			if not anim_player.is_playing():
				anim_player.play("swipe")
		GameData.Weapon.CLEAVER:
			if not anim_player.is_playing():
				anim_player.play("big_swipe")

func ranged_attack():
	match(GameData.curr_player_weapon):
		GameData.Weapon.STAFF:
			if can_fire:
				fire_orb()
			
func fire_orb():
	can_fire = false
	var orb_instance = orb.instantiate()
	get_parent().call_deferred("add_child", orb_instance)
	$Staff/StaffCooldown.start()

func set_lock_swipe_rotation(val: bool):
	lock_swipe_rotation = val

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(5, 8)


func _on_big_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(10, 15)

func _on_staff_cooldown_timeout() -> void:
	can_fire = true
