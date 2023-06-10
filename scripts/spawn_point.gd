extends Node2D

var enemy_to_spawn
var spawn_points

func spawn(enemy, room_spawn_points):
	enemy_to_spawn = enemy
	spawn_points = room_spawn_points
	$AnimationPlayer.play("spawn")

func spawn_anim_finish():
	var enemy_instance = enemy_to_spawn["value"].instantiate()
	if enemy_to_spawn["type"] == "goblin_wizard":
		enemy_instance.spawn_points = spawn_points
	get_tree().current_scene.call_deferred("add_child", enemy_instance)
	enemy_instance.global_position = global_position
