extends CharacterBody2D

@onready var player_sprite: Sprite2D = $Sprite2D

@export var speed := 300

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
	elif velocity.x > 0:
		player_sprite.flip_h = false
