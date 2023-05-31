extends CharacterBody2D

@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var knockback_timer: Timer = $KnockbackTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var base_speed := 300.0
@export var health := 20

var curr_speed = base_speed
var is_knocked_back = false
var knockback_multiplier = 15

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
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
	if direction.y > 0:
		sprite.play("walk_forward")
	elif direction.y < 0:
		sprite.play("walk_back")
	elif direction.x > 0:
		sprite.play("walk_side")
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.play("walk_side")
		sprite.flip_h = true

func take_damage(damage: int, knockback_mult: float):
	knockback_multiplier = knockback_mult
	health -= damage
	is_knocked_back = true
	knockback_timer.start()
	if health <= 0:
		SignalBus.enemy_dead.emit()
		queue_free()

func _on_knockback_timer_timeout() -> void:
	is_knocked_back = false
