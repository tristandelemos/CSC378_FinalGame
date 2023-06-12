extends Node

var most_monsters_killed = 0
var total_kills = 0
var current_kills = 0
var rooms_entered = 0
var weapons_collected = [GameData.Weapon.DAGGER]
var total_coins_collected = 0
var characters = {
	"telonia": {
		"name": "Telonia",
		"type": "Protagonist",
		"description": "You are the main character",
		"amount_killed": 0,
		"image_path": "res://sprites/main character/t_front_facing.png"
	},
	"goblin": {
		"name": "Goblin",
		"type": "Hostile Mob",
		"description": "Follows and attacks you",
		"amount_killed": 0,
		"image_path": "res://sprites/enemies/known_goblin.png"
	},
	"goblinWizard" : {
		"name": "Goblin Wizard",
		"type": "Hostile Mob",
		"description": "Throws fireballs and teleports",
		"amount_killed": 0,
		"image_path": "res://sprites/enemies/known_goblin_wizard.png"
	},
	"death": {
		"name": "Death",
		"type": "Final Boss",
		"description": "The personification of death",
		"amount_killed": 0,
		#CHANGE
		"image_path": "res://sprites/character_updown.png"
	},
	"ladyLuck": {
		"name": "Lady Luck",
		"type": "Unknown",
		"description": "Helpful patron to assist on runs",
		"amount_killed": "Cannot die",
		"image_path": "res://sprites/lady_luck.png"
	},
	"shopkeeper": {
		"name": "Shopkeeper",
		"type": "Human NPC",
		"description": "Man trying to make a quick buck",
		"amount_killed": "Cannot die",
		"image_path": "res://sprites/shopkeeper/known_shopkeeper.png"
	}
}

func killed_enemy(enemy_type):
	characters[enemy_type].amount_killed += 1
