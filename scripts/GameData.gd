extends Node

enum Weapon {
	DAGGER,
	CLEAVER,
	STAFF
}

# Base Data
# Debug Options
var skip_intro_cutscene: bool = false

# Player Data
var base_player_health: int = 10
var base_player_weapon: Weapon = Weapon.DAGGER

#####################################################
# Current Data
# Player Data
var curr_player_health: int = base_player_health
var curr_player_weapon: Weapon = base_player_weapon
var curr_souls: int = 0

# Functions
func get_weapon_sprite(weapon: Weapon):
	match(weapon):
		Weapon.DAGGER:
			return load("res://sprites/dagger.png")
		Weapon.CLEAVER:
			return load("res://sprites/cleaver.png")
		Weapon.STAFF:
			return load("res://sprites/staff.png")
