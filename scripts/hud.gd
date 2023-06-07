extends CanvasLayer
class_name HUD

@onready var minimap = $Minimap
@onready var minirooms = $Minimap/MiniRooms
@onready var coin_count: Label = $Coin/Count
@onready var soul_count: Label = $Souls/Count
@onready var death_screen = $DeathScreen

func _ready() -> void:
	$DeathScreen.visible = false
	$Minimap.visible = false
	update_coin_count()
	update_soul_count()
	SignalBus.player_enter.connect(_on_player_enter)
	SignalBus.player_exit.connect(_on_player_exit)
	SignalBus.update_weapon_slot.connect(update_weapon_slot)
	SignalBus.coin_collected.connect(update_coin_count)
	SignalBus.soul_collected.connect(update_soul_count)
	SignalBus.player_dead.connect(_on_player_dead)
	update_weapon_slot(GameData.curr_player_weapon)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("minimap"):
		minimap.visible = true
	if event.is_action_released("minimap"):
		minimap.visible = false

func update_coin_count():
	coin_count.text = "%05d" % GameData.curr_coins

func update_soul_count():
	soul_count.text = "%05d" % GameData.curr_souls

func update_weapon_slot(weapon: GameData.Weapon):
	match(weapon):
		GameData.Weapon.CLEAVER:
			$WeaponSlot/Sprite2D.texture = load("res://sprites/cleaver.png")
		GameData.Weapon.DAGGER:
			$WeaponSlot/Sprite2D.texture = load("res://sprites/dagger.png")
		GameData.Weapon.STAFF:
			$WeaponSlot/Sprite2D.texture = load("res://sprites/staff.png")

func _on_player_enter(instance_id: int):
	for miniroom in minirooms.get_children():
		if miniroom.room == instance_id:
			miniroom._on_player_enter()
			return

func _on_player_exit(instance_id: int):
	for miniroom in minirooms.get_children():
		if miniroom.room == instance_id:
			miniroom._on_player_exit()
			return

func find_miniroom(instance_id: int):
	for miniroom in minirooms.get_children():
		if miniroom.room == instance_id:
			return miniroom

func _on_player_dead() -> void:
	get_tree().paused = true
	death_screen.visible = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	GameData.reset()
	get_tree().change_scene_to_file("res://levels/overworld.tscn")
