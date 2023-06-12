extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var orb = preload("res://instances/staff_orb.tscn")
@onready var player = get_parent()
@onready var arrow = preload("res://instances/bow_arrow.tscn")

var can_fire := true
var drawback := true
var lock_swipe_rotation := false

func _process(delta: float) -> void:
	if not GameData.freeze_player:
		if not lock_swipe_rotation:
			look_at(get_global_mouse_position())
		if Input.is_action_pressed("attack"):
			ranged_attack()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and not GameData.freeze_player:
		melee_attack()

func melee_attack():
	match(GameData.curr_player_weapon):
		GameData.Weapon.DAGGER:
			if not anim_player.is_playing():
				anim_player.play("swipe")
		GameData.Weapon.CLEAVER:
			if not anim_player.is_playing():
				anim_player.play("big_swipe")

func nudge():
	player.nudge(global_position.direction_to(get_global_mouse_position()), 500)

func update_player_sprite():
	player.look_at_mouse(global_position.direction_to(get_global_mouse_position()))

func toggle_player_movement():
	GameData.freeze_player = not GameData.freeze_player

func ranged_attack():
	match(GameData.curr_player_weapon):
		GameData.Weapon.STAFF:
			if can_fire:
				anim_player.play("staff")
				fire_orb()
		# Add in bow and arrow animation
		GameData.Weapon.BOW:
			if can_fire:
				anim_player.play("bow")
				shoot_arrow()
			
func fire_orb():
	can_fire = false
	var orb_instance = orb.instantiate()
	orb_instance.global_position = get_parent().global_position
	get_tree().current_scene.call_deferred("add_child", orb_instance)
	$Staff/StaffCooldown.start()
	
func shoot_arrow():
	can_fire = false
	var arrow_instance = arrow.instantiate()
	arrow_instance.global_position = get_parent().global_position
	get_tree().current_scene.call_deferred("add_child", arrow_instance)
	$Bow/BowCooldown.start()

func set_lock_swipe_rotation(val: bool):
	lock_swipe_rotation = val

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(50)

func _on_big_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(10)

func _on_staff_cooldown_timeout() -> void:
	can_fire = true

func _on_bow_cooldown_timeout() -> void:
	can_fire = true
	

