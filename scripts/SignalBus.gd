extends Node

signal player_enter(instance_id)
signal player_exit(instance_id)
signal boss_damaged(curr_health)
signal fight_start
signal fight_end
signal health_pickup
signal player_damaged
signal player_dead
signal enemy_dead
signal update_weapon_slot(weapon)
signal drop_current_weapon()
signal coin_collected()
signal soul_collected()
signal update_health_potion_hud
signal boss_phase_change(phase)
signal boss_dead
