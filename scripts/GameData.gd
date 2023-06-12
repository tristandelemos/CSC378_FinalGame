extends Node

enum Weapon {
	DAGGER,
	CLEAVER,
	STAFF,
	BOW,
	CLUB,
	SCYTHE
}

# Base Data
# Debug Options
var skip_intro_cutscene: bool = false
var lady_luck_intro := false

# Player Data
var freeze_player: bool = false
var base_player_health: int = 100
var base_player_weapon: Weapon = Weapon.DAGGER
var base_soul_drop_chance: float = 0.0
var base_health_potions: int = 0
var base_coins: int = 0
var base_stamina: int = 100
var deaths: int = 1

var shopkeeper_room_unlocked = false
var weapon_loot_room_unlocked = false
var unlock_weapon_loot_room_cost := 30
var unlock_shopkeeper_room_cost := 0
var increase_starting_coins_cost := 5
var increase_soul_drop_cost := 5
var increase_starting_health_cost := 10
var increase_potion_cost := 0
var increase_dash_cost := 30

# Enemy Data
var base_waves = 2
var base_min_enemy_spawn = 4
var base_max_enemy_spawn = 6
var base_enemy_speed = 70.0
var base_enemy_health = 15
var base_enemy_damage = 10

#####################################################
# Current Data
var difficulty_multiplier = 0
var level = 0
# Player Data
var curr_player_health: int = base_player_health
var curr_player_weapon: Weapon = base_player_weapon
var curr_health_potions: int = base_health_potions
var curr_coins: int = base_coins
var curr_souls: int = 0

# Enemy Data
var difficulty_increase_multiplier = 4 # Every 2 enemy rooms after the first, increase difficulty
var curr_min_enemy_spawn = base_min_enemy_spawn
var curr_max_enemy_spawn = base_max_enemy_spawn
var curr_enemy_speed = base_enemy_speed
var curr_enemy_health = base_enemy_health
var curr_enemy_damage = base_enemy_damage

# Functions
@onready var rooms: Array[Dictionary] = [
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_one.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_two.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_three.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_four.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_five.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_six.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_seven.tscn")
	},
	{
		"type": "enemy",
		"resource": preload("res://instances/rooms/enemy_room_eight.tscn")
	}
]

@onready var enemies: Array[Dictionary] = [
	{
		"value": preload("res://instances/enemy.tscn"),
		"type": "goblin",
		"weight": 80.0
	},
	{
		"value": preload("res://instances/goblin_wizard.tscn"),
		"type": "goblin_wizard",
		"weight": 20.0
	},
]

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)

func _on_dialogue_end(resource: DialogueResource):
	var title = resource.get_titles()[0]
	freeze_player = false
	if title == "intro_lady_luck":
		lady_luck_intro = true
		base_soul_drop_chance = 0.25

func reset():
	freeze_player = false
	curr_player_health = base_player_health
	curr_player_weapon = base_player_weapon
	curr_coins = base_coins
	difficulty_multiplier = 0
	curr_min_enemy_spawn = base_min_enemy_spawn
	curr_max_enemy_spawn = base_max_enemy_spawn
	curr_enemy_speed = base_enemy_speed
	curr_enemy_health = base_enemy_health
	curr_enemy_damage = base_enemy_damage
	curr_health_potions = base_health_potions

func increase_difficulty():
	if difficulty_multiplier % difficulty_increase_multiplier == 0:
		base_waves += 1
	difficulty_multiplier += 1

func get_weapon_sprite(weapon: Weapon):
	match(weapon):
		Weapon.DAGGER:
			return load("res://sprites/dagger.png")
		Weapon.CLEAVER:
			return load("res://sprites/cleaver.png")
		Weapon.STAFF:
			return load("res://sprites/staff.png")
		Weapon.BOW:
			return load("res://sprites/bow_arrow.png")
		Weapon.CLUB:
			return load("res://sprites/vlub.png")
		Weapon.SCYTHE:
			return load("res://sprites/scythe.png")

func get_player_in_scene():
	return get_tree().current_scene.get_node("Player")
