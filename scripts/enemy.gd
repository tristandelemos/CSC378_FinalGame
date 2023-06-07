extends CharacterBody2D
class_name Enemy

@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var curr_scene = get_tree().current_scene
@onready var coin = preload("res://instances/coin.tscn")
@onready var soul = preload("res://instances/soul.tscn")
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar

var health
@export var min_coin := 1
@export var max_coin := 5

var damage
var is_knocked_back = false
var knockback_multiplier = 15
var direction: Vector2

func _ready() -> void:
	health = GameData.curr_enemy_health
	healthbar.max_value = GameData.base_enemy_health
	healthbar.value = GameData.curr_enemy_health
	damage = GameData.curr_enemy_damage

func take_damage(damage: int):
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
