extends Control


func _on_start_pressed():
	get_tree().change_scene_to_file("res://levels/overworld.tscn")



func _on_credits_pressed():
	get_tree().change_scene_to_file("res://instances/credits.tscn")
