extends Control



	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://instances/backstory.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://instances/credits.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://instances/controls_screen.tscn")


func _on_ready():
	$AnimatedSprite2D.play("real_death")
