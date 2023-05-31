extends CharacterBody2D

@onready var player_sprite: Sprite2D = $Sprite2D
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sword : Area2D = $Sprite2D/Sword
@onready var hud = $HUD
@export var speed := 300

var direction : String = "left"

func _ready():
	pass

func _physics_process(delta) -> void:
	handle_movement()
	flip_sprite()
	move_and_slide()

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
		sword.rotation_degrees = 180
	elif velocity.x > 0:
		player_sprite.flip_h = false
		sword.rotation_degrees = 0
	if velocity.y < 0:
		player_sprite.flip_v = false
		sword.rotation_degrees = 0
	elif velocity.y > 0:
		player_sprite.flip_v = true
		sword.rotation_degrees = 180



func _input(event):
	if event.is_action_pressed("up") or event.is_action_pressed("down"):
		direction = "vertical"
		animation.play("vertical")
	elif event.is_action_pressed("left") or event.is_action_pressed("right"):
		direction = "sideways"
		animation.play("sideways")
	if event.is_action_pressed("attack"):
		if direction == "sideways":
			animation.play("attack_side")
		else:
			animation.play("attack_vert")
