extends CanvasLayer
class_name HUD

@onready var encyclopedia = $Encyclopedia
@onready var minimap = $Minimap
@onready var minirooms = $Minimap/MiniRooms
@onready var coin_count: Label = $Coin/Count
@onready var soul_count: Label = $Souls/Count
@onready var death_screen = $DeathScreen
@onready var health_potion_sprites = $HealthPotions.get_children()
@onready var empty_bottle_texture = preload("res://sprites/health_potion_empty.png")
@onready var health_bottle_texture = preload("res://sprites/health_potion.png")

var current_potion_index = 0
var e_toggle = false

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
	if event.is_action_pressed("encyclopedia"):
		toggle_encyclopedia(!e_toggle)

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
	
### ENCYCLOPEDIA FUNCTIONS ###encyclopedia
func toggle_encyclopedia(toggle: bool):
	encyclopedia.visible = toggle
	get_tree().paused = toggle
	update_enemies($Encyclopedia/VBoxContainer/Characters/HBoxContainer/Goblin/Goblin/Goblin, "goblin")
	update_enemies($"Encyclopedia/VBoxContainer/Characters/HBoxContainer/Goblin Wizard/Goblin Wizard/Goblin Wizard", "goblinWizard")
	update_people($"Encyclopedia/VBoxContainer/Characters/HBoxContainer/Lady Luck/Lady Luck/Lady Luck", "ladyLuck")
	update_people($Encyclopedia/VBoxContainer/Characters/HBoxContainer/Shopkeeper/Shopkeeper/Shopkeeper, "shopkeeper")
	update_stats($Encyclopedia/VBoxContainer/TopRow/HBoxContainer/Stats/Stats/VBoxContainer)
	e_toggle = toggle
	
func update_enemies(node_path : Node, enemy_name : String):
	if Encyclopedia.characters[enemy_name].amount_killed > 0:
		node_path.get_child(0).texture = load(Encyclopedia.characters[enemy_name].image_path)
		node_path.get_child(1).text = Encyclopedia.characters[enemy_name].name
		node_path.get_child(2).text = "Type: " + Encyclopedia.characters[enemy_name].type
		node_path.get_child(3).text = Encyclopedia.characters[enemy_name].description
		node_path.get_child(4).text = "Total Killed: " + str(Encyclopedia.characters[enemy_name].amount_killed)

func update_people(node_path : Node, character : String):
	if character == "ladyLuck":
		if GameData.lady_luck_intro:
			node_path.get_child(0).texture = load(Encyclopedia.characters[character].image_path)
			node_path.get_child(1).text = Encyclopedia.characters[character].name
			node_path.get_child(2).text = "Type: " + Encyclopedia.characters[character].type
			node_path.get_child(3).text = Encyclopedia.characters[character].description
			node_path.get_child(4).text = Encyclopedia.characters[character].amount_killed
	if character == "shopkeeper":
		if GameData.shopkeeper_room_unlocked:
			node_path.get_child(0).texture = load(Encyclopedia.characters[character].image_path)
			node_path.get_child(1).text = Encyclopedia.characters[character].name
			node_path.get_child(2).text = "Type: " + Encyclopedia.characters[character].type
			node_path.get_child(3).text = Encyclopedia.characters[character].description
			node_path.get_child(4).text = Encyclopedia.characters[character].amount_killed

func update_stats(node_path : Node):
	node_path.get_child(1).text = "Total deaths: " + str(GameData.deaths)
	node_path.get_child(2).text = "Total # of kills: " + str(Encyclopedia.total_kills)
	node_path.get_child(3).text = "Most # of kills in a run: " + str(Encyclopedia.most_monsters_killed)
	node_path.get_child(4).text = "Current run kill count: " + str(Encyclopedia.current_kills)
	node_path.get_child(5).text = "Total coins collected: " + str(Encyclopedia.total_coins_collected)
	node_path.get_child(6).text = "Total rooms entered: " + str(Encyclopedia.rooms_entered)
