extends State
class_name GroundState

@export var player : CharacterBody2D
@export var attack_state : State
@export var attack_animation : String = "attack"

func _input(event):
	if event.is_action_pressed("attack"):
		attack()
		
func attack():
	if player.direction == "up" or player.direction == "down":
		pass
	else:
		pass
		
