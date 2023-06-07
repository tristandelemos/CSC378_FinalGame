extends Enemy

var base_speed

var curr_speed = base_speed

func _ready() -> void:
	super._ready()
	base_speed = GameData.curr_enemy_speed

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
