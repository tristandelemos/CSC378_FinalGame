extends CharacterBody2D

@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var knockback_timer: Timer = $KnockbackTimer

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
    velocity = direction * curr_speed
    move_and_slide()

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
