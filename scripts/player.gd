extends CharacterBody2D
class_name Player

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hud = $HUD
@onready var loot = preload("res://instances/loot.tscn")
@onready var healthbar = $HealthBar
@onready var staminabar = $StaminaBar
@onready var anim_player = $AnimationPlayer
@onready var knockback_timer = $KnockbackTimer

@export var speed := 150

var curr_stamina := GameData.base_stamina
var lock_swipe_rotation: bool = false
var knockback: bool = false
var knockback_dir: Vector2
var dashing = false
var nudging = false
var nudge_power = 0
var nudge_direction = Vector2.ZERO

func _ready() -> void:
	staminabar.max_value = GameData.base_stamina
	staminabar.value = curr_stamina
	healthbar.max_value = GameData.base_player_health
	healthbar.value = GameData.curr_player_health
	SignalBus.health_pickup.connect(_on_health_pickup)
	SignalBus.drop_current_weapon.connect(_on_drop_current_weapon)
	SignalBus.fight_start.connect(_on_fight_start)
	SignalBus.fight_end.connect(_on_fight_end)
	$PointLight2D.visible = true

func _physics_process(delta) -> void:
	if curr_stamina < GameData.base_stamina:
		curr_stamina += 2
		staminabar.value = curr_stamina
	if nudging and velocity == Vector2.ZERO:
		velocity += nudge_direction * nudge_power
	elif GameData.freeze_player:
		velocity = Vector2.ZERO
	elif not dashing:
		handle_movement()
		handle_animation()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash"):
		dash()
	if event.is_action_pressed("health_potion"):
		use_health_potion()

func _on_base_stamina_update():
	staminabar.max_value = GameData.base_stamina

func use_health_potion():
	if GameData.curr_health_potions > 0 and GameData.curr_player_health < GameData.base_player_health:
		$DrinkSound.play()
		GameData.curr_player_health += 50
		if GameData.curr_player_health > GameData.base_player_health:
			GameData.curr_player_health = GameData.base_player_health
		healthbar.value = GameData.curr_player_health
		GameData.curr_health_potions -= 1
		SignalBus.update_health_potion_hud.emit()
	
func _on_fight_start():
	anim_player.queue("fight_start")

func _on_fight_end():
	anim_player.queue("fight_end")

func _on_drop_current_weapon():
	var dropped_weapon: Loot = loot.instantiate()
	dropped_weapon.weapon = GameData.curr_player_weapon
	dropped_weapon.global_position = global_position
	dropped_weapon.setup()
	get_tree().current_scene.call_deferred("add_child", dropped_weapon)

func handle_movement() -> void:
	var y_direction = Input.get_axis("up", "down")
	if y_direction:
		velocity.y = y_direction * speed
	else:
		velocity.y = 0
	var x_direction = Input.get_axis("left", "right")
	if x_direction:
		velocity.x = x_direction * speed
	else:
		velocity.x = 0

func dash():
	if curr_stamina >= 100 and not dashing:
		$WooshSound.play()
		curr_stamina -= 100
		staminabar.value = curr_stamina
		velocity *= 7
		dashing = true
		$DashTimer.start()

func nudge(direction: Vector2, power: int):
	nudge_direction = direction
	nudge_power = power
	nudging = true
	$NudgeTimer.start()

func handle_animation():
	if velocity.y < 0:
		player_sprite.play("walk_back")
	elif velocity.y > 0:
		player_sprite.play("walk_front")
	else:
		if velocity.x > 0:
			player_sprite.play("walk_right")
		if velocity.x < 0:
			player_sprite.play("walk_left")
	if velocity == Vector2.ZERO:
		player_sprite.frame = 0
		$WalkSound.stop()
	else:
		if not $WalkSound.playing:
			$WalkSound.play()

func look_at_mouse(direction: Vector2):
	if direction.y > 0 and abs(direction.y) > abs(direction.x):
		player_sprite.play("walk_front")
	elif direction.y < 0 and abs(direction.y) > abs(direction.x):
		player_sprite.play("walk_back")
	elif direction.x > 0 and abs(direction.y) < abs(direction.x):
		player_sprite.play("walk_right")
	elif direction.x < 0 and abs(direction.y) < abs(direction.x):
		player_sprite.play("walk_left")
	player_sprite.stop()
	player_sprite.frame = 0

func take_damage(damage: int):
	GameData.curr_player_health -= damage
	healthbar.value = GameData.curr_player_health
	if GameData.curr_player_health <= 0:
		GameData.deaths += 1
		Encyclopedia.current_kills = 0
		SignalBus.player_dead.emit()
	anim_player.play("damaged")

func _on_health_pickup():
	healthbar.value = GameData.curr_player_health

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if not dashing:
		SignalBus.player_damaged.emit()
		take_damage(body.damage)
		knockback_timer.start()
		knockback = true
		knockback_dir = body.direction

func _on_knockback_timer_timeout() -> void:
	knockback = false

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_nudge_timer_timeout() -> void:
	nudging = false
