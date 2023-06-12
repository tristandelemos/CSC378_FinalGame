extends TextureButton
class_name ShopSlot3

@onready var loot = preload("res://instances/loot.tscn")
@onready var label = $Label

@export var cost: int = 100

func green_text():
	label.add_theme_color_override("font_color", Color(0, 255, 0, 255))

func red_text():
	label.add_theme_color_override("font_color", Color(255, 0, 0, 255))

func _on_pressed() -> void:
	if GameData.curr_coins > cost:
		GameData.curr_coins -= cost
		SignalBus.coin_collected.emit()
		var weapon_instance: Loot = loot.instantiate()
		weapon_instance.weapon = GameData.Weapon.CLUB
		print(GameData.get_player_in_scene())
		weapon_instance.global_position =  GameData.get_player_in_scene().global_position
		weapon_instance.setup()
		get_tree().current_scene.call_deferred("add_child", weapon_instance)
