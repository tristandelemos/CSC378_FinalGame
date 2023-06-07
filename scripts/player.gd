extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var hud = $HUD
@onready var loot = preload("res://instances/loot.tscn")
@onready var healthbar = $HealthBar
@onready var anim_player = $AnimationPlayer
@onready var knockback_timer = $KnockbackTimer

@export var speed := 300

var lock_swipe_rotation: bool = false
var knockback: bool = false
var knockback_dir: Vector2

func _ready() -> void:
	healthbar.value = GameData.curr_player_health
	SignalBus.drop_current_weapon.connect(_on_drop_current_weapon)
	$PointLight2D.visible = true

func _physics_process(delta) -> void:
	if not GameData.freeze_player:
		if knockback:
			velocity = knockback_dir * 500
		else:
			handle_movement()
			flip_sprite()
		move_and_slide()

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

func flip_sprite() -> void:
	if velocity.x < 0:
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false

func take_damage(damage: int):
	GameData.curr_player_health -= damage
	healthbar.value = GameData.curr_player_health
	if GameData.curr_player_health <= 0:
		GameData.deaths += 1
		SignalBus.player_dead.emit()
	anim_player.play("damaged")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	take_damage(body.damage)
	knockback_timer.start()
	knockback = true
	knockback_dir = body.direction

func _on_knockback_timer_timeout() -> void:
	knockback = false
