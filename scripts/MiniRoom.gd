extends ColorRect

@export var room: int
var visited: bool = false

func _on_player_enter():
	visited = true
	player_in_room()

func _on_player_exit():
	player_exited()

func player_in_room():
	color = Color(255, 255, 0, 255)

func player_exited():
	color = Color(255, 255, 255, 255)
