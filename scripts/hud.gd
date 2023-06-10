extends CanvasLayer
class_name HUD

@onready var minimap = $Minimap
@onready var minirooms = $Minimap/MiniRooms
@onready var coin_count: Label = $Coin/Count
@onready var soul_count: Label = $Souls/Count
@onready var death_screen = $DeathScreen
@onready var health_potion_sprites = $HealthPotions.get_children()
@onready var empty_bottle_texture = preload("res://sprites/health_potion_empty.png")
@onready var health_bottle_texture = preload("res://sprites/health_potion.png")

var current_potion_index = 0

func _ready() -> void:
	$DeathScreen.visible = false
	$Minimap.visible = false
	update_coin_count()
	update_soul_count()
	SignalBus.player_damaged.connect(_on_player_damaged)
	SignalBus.player_enter.connect(_on_player_enter)
	SignalBus.player_exit.connect(_on_player_exit)
	SignalBus.update_weapon_slot.connect(update_weapon_slot)
	SignalBus.coin_collected.connect(update_coin_count)
	SignalBus.soul_collected.connect(update_soul_count)
	SignalBus.player_dead.connect(_on_player_dead)
	SignalBus.update_health_potion_hud.connect(_on_update_health_potion_hud)
	update_weapon_slot(GameData.curr_player_weapon)
	for potion_sprite in health_potion_sprites:
		potion_sprite.visible = false
	for i in range(GameData.base_health_potions):
		health_potion_sprites[i].visible = true
	for i in range(GameData.curr_health_potions):
		health_potion_sprites[i].texture = health_bottle_texture

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("minimap"):
		minimap.visible = true
	if event.is_action_released("minimap"):
		minimap.visible = false

func _on_update_health_potion_hud():
	for i in range(GameData.base_health_potions):
		health_potion_sprites[i].visible = true
		health_potion_sprites[i].texture = empty_bottle_texture
	for i in range(GameData.curr_health_potions):
		health_potion_sprites[i].texture = health_bottle_texture

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

func _on_player_damaged():
	$HudHit/AnimationPlayer.play("hit")

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
