extends CharacterBody2D

@onready var erupt_attack = preload("res://instances/erupt_attack.tscn")
@onready var orb = preload("res://instances/boss_orb.tscn")
@onready var anchors: Array[Node] = get_tree().current_scene.get_node("Anchors").get_children()
@onready var room_rect = get_tree().current_scene.get_node("RoomArea/CollisionShape2D").shape.get_rect()
@onready var level = get_tree().current_scene
@onready var player = get_tree().current_scene.get_node("Player")
@onready var projectile_spawn = $ProjectileSpawn

@export var speed := 300

var attacks = ["erupt"]

var health = 300
var target_pos = null
var should_move_to_target := false
var attacking = false
var can_erupt = true
var can_throw = true
var targeted_attack = false
var knockback = false
var attack_type
var multi_target

var phase = 0
var phase_one_threshold = 200
var phase_two_threshold = 100

func _physics_process(delta: float) -> void:
	projectile_spawn.look_at(player.global_position)
	if knockback:
		var knockback_dir = global_position.direction_to(player.global_position) * -1
		velocity = knockback_dir * 200
	else:
		velocity = Vector2.ZERO
	if should_move_to_target:
		if global_position.distance_to(target_pos) < 10:
			$CollisionShape2D.disabled = false
			attacking = true
			var roll = RngUtils.int_range(0, 100)
			targeted_attack = roll > 50
			attack_type = RngUtils.array(attacks)[0]
			multi_target = global_position.direction_to(player.global_position)
			velocity = Vector2.ZERO
			should_move_to_target = false
		else:
			$CollisionShape2D.disabled = true
			var direction = global_position.direction_to(target_pos)
			velocity = direction * speed
	if attacking:
		attack()
	move_and_slide()

func attack():
	match(attack_type):
		"erupt":
			if can_erupt:
				can_erupt = false
				var roll = RngUtils.int_range(0, 100)
				var chosen_anchor = Vector2(
					RngUtils.float_range(
						room_rect.position.x, room_rect.end.x), 
					RngUtils.float_range(
						room_rect.position.y, room_rect.end.y)) if not targeted_attack else player.global_position
				var erupt_attack_instance = erupt_attack.instantiate()
				erupt_attack_instance.global_position = chosen_anchor
				level.call_deferred("add_child", erupt_attack_instance)
				$EruptAttackCooldown.start()
				if $EruptAttackLength.is_stopped():
					$EruptAttackLength.start()
		"throw":
			if can_throw:
				can_throw = false
				var orb_instance = orb.instantiate()
				orb_instance.global_position = global_position
				orb_instance.target = global_position.direction_to(player.global_position)
				level.call_deferred("add_child", orb_instance)
				$ThrowAttackCooldown.start()
				if $ThrowAttackLength.is_stopped():
					$ThrowAttackLength.start()
		"throw_multi":
			if can_throw:
				can_throw = false
				for i in range(8):
					var orb_instance = orb.instantiate()
					orb_instance.global_position = global_position
					orb_instance.target = multi_target
					multi_target = multi_target.rotated(deg_to_rad(45))
					level.call_deferred("add_child", orb_instance)
					$ThrowAttackCooldown.start()
					if $ThrowAttackLength.is_stopped():
						$ThrowAttackLength.start()
				multi_target = multi_target.rotated(deg_to_rad(10))

func take_damage(damage: int):
	health -= damage
	if phase == 0 and health <= phase_one_threshold:
		speed += 100
		health = phase_one_threshold
		phase += 1
		attacks.append("throw")
		SignalBus.boss_phase_change.emit(phase)
	elif phase == 1 and health <= phase_two_threshold:
		speed += 100
		$MoveTimer.wait_time = 2.0
		health = phase_two_threshold
		phase += 1
		attacks.append("throw_multi")
		SignalBus.boss_phase_change.emit(phase)
	if health <= 0:
		queue_free()
		SignalBus.boss_dead.emit()
	SignalBus.boss_damaged.emit(health)
	knockback = true
	$KnockbackTimer.start()

func _on_move_timer_timeout() -> void:
	target_pos = RngUtils.array(anchors)[0].global_position
	should_move_to_target = true

func stop_attacking() -> void:
	$MoveTimer.start()
	attacking = false

func _on_erupt_attack_cooldown_timeout() -> void:
	can_erupt = true

func _on_knockback_timer_timeout() -> void:
	knockback = false

func _on_throw_attack_cooldown_timeout() -> void:
	can_throw = true


func _on_throw_attack_length_timeout() -> void:
	pass # Replace with function body.
