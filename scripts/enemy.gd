extends CharacterBody2D

@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var curr_scene = get_tree().current_scene
@onready var coin = preload("res://instances/coin.tscn")
@onready var soul = preload("res://instances/soul.tscn")
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar

var base_speed
var damage
var health
@export var min_coin := 1
@export var max_coin := 5

var curr_speed = base_speed
var is_knocked_back = false
var knockback_multiplier = 15
var direction: Vector2

func _ready() -> void:
	base_speed = GameData.curr_enemy_speed
	damage = GameData.curr_enemy_damage
	health = GameData.curr_enemy_health
	healthbar.value = health

func _physics_process(delta: float) -> void:
	direction = global_position.direction_to(player.global_position)
	if is_knocked_back:
		direction *= -1
		if curr_speed == base_speed:
			curr_speed *= knockback_multiplier
	else:
		curr_speed = base_speed
		update_sprite(direction)
	velocity = direction * curr_speed
	move_and_slide()

func update_sprite(direction: Vector2):
	if direction.y > 0 and abs(direction.y) > abs(direction.x):
		sprite.play("walk_forward")
	elif direction.y < 0 and abs(direction.y) > abs(direction.x):
		sprite.play("walk_back")
	elif direction.x > 0 and abs(direction.y) < abs(direction.x):
		sprite.play("walk_side")
		sprite.flip_h = false
	elif direction.x < 0 and abs(direction.y) < abs(direction.x):
		sprite.play("walk_side")
		sprite.flip_h = true 

func take_damage(damage: int, knockback_mult: float = 0.0):
	knockback_multiplier = knockback_mult
	health -= damage
	healthbar.value = health
	is_knocked_back = true
	knockback_timer.start()
	if health <= 0:
		var soul_roll = RngUtils.float_range(0, 1)
		if soul_roll <= GameData.base_soul_drop_chance:
			var soul_instance = soul.instantiate()
			soul_instance.global_position = global_position
			curr_scene.call_deferred("add_child", soul_instance)
		var num_coin_drop = RngUtils.int_range(min_coin, max_coin)
		for i in range(num_coin_drop):
			var coin_instance = coin.instantiate()
			coin_instance.global_position = global_position
			curr_scene.call_deferred("add_child", coin_instance)
		SignalBus.enemy_dead.emit()
		queue_free()

func _on_knockback_timer_timeout() -> void:
	is_knocked_back = false
