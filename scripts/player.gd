extends CharacterBody2D
class_name Player

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var hud = $HUD
@onready var loot = preload("res://instances/loot.tscn")

@export var speed := 300
@export var health := 100
@export var damage := 10

var curr_player_health: int
var lock_swipe_rotation: bool = false

func _ready() -> void:
	curr_player_health = GameData.curr_player_health
	SignalBus.drop_current_weapon.connect(_on_drop_current_weapon)
	$PointLight2D.visible = true

func _physics_process(delta) -> void:
	handle_movement()
	flip_sprite()
	move_and_slide()

func _on_drop_current_weapon():
	var dropped_weapon: Loot = loot.instantiate()
	dropped_weapon.weapon = GameData.curr_player_weapon
	dropped_weapon.global_position = global_position
	dropped_weapon.setup()
	get_tree().current_scene.call_deferred("add_child", dropped_weapon)

func _on_take_damage(damage: int):
	pass

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

func _on_hitbox_body_entered(body: Node2D) -> void:
	body.take_damage(damage, 200)
