extends CanvasLayer

@onready var unlock_weapon_loot_room_cost_label = $ColorRect/UnlockWeaponLootRoomButton/Cost/Label
@onready var unlock_shopkeeper_room_cost_label = $ColorRect/UnlockShopkeeperRoomButton/Cost/Label
@onready var increase_starting_coins_cost_label = $ColorRect/IncreaseStartingCoinsButton/Cost/Label
@onready var increase_soul_drop_cost_label = $ColorRect/InceaseSoulDropButton/Cost/Label
@onready var increase_starting_health_cost_label = $ColorRect/IncreaseStartingHealthButton/Cost/Label
@onready var incrase_potion_cost_label = $ColorRect/IncreasePotionButton/Cost/Label
@onready var increase_dash_cost_label = $ColorRect/IncreaseDashButton/Cost/Label

func _ready() -> void:
	visible = false
	if GameData.weapon_loot_room_unlocked:
		$ColorRect/UnlockWeaponLootRoomButton.queue_free()
	if GameData.shopkeeper_room_unlocked:
		$ColorRect/UnlockShopkeeperRoomButton.queue_free()
	unlock_weapon_loot_room_cost_label.text = "%d" % GameData.unlock_weapon_loot_room_cost
	unlock_shopkeeper_room_cost_label.text = "%d" % GameData.unlock_shopkeeper_room_cost
	increase_starting_coins_cost_label.text = "%d" % GameData.increase_starting_coins_cost
	increase_soul_drop_cost_label.text = "%d" % GameData.increase_soul_drop_cost
	increase_starting_health_cost_label.text = "%d" % GameData.increase_starting_health_cost
	incrase_potion_cost_label.text = "%d" % GameData.increase_potion_cost
	increase_dash_cost_label.text = "%d" % GameData.increase_dash_cost

func _on_unlock_weapon_loot_room_button_pressed() -> void:
	if GameData.curr_souls >= GameData.unlock_weapon_loot_room_cost:
		GameData.rooms.append(
		{
			"type": "loot",
			"resource": preload("res://instances/rooms/loot_room_one.tscn")
		})
		GameData.curr_souls -= GameData.unlock_weapon_loot_room_cost
		$ColorRect/UnlockWeaponLootRoomButton.queue_free()
		SignalBus.soul_collected.emit()
		GameData.weapon_loot_room_unlocked = true

func _on_unlock_shopkeeper_room_button_pressed() -> void:
	if GameData.curr_souls >= GameData.unlock_shopkeeper_room_cost:
		GameData.rooms.append(
		{
			"type": "shop",
			"resource": preload("res://instances/rooms/shopkeeper_room.tscn")
		})
		GameData.curr_souls -= GameData.unlock_shopkeeper_room_cost
		$ColorRect/UnlockShopkeeperRoomButton.queue_free()
		SignalBus.soul_collected.emit()
		GameData.shopkeeper_room_unlocked = true

func _on_increase_starting_coins_button_pressed() -> void:
	if GameData.curr_souls >= GameData.increase_starting_coins_cost:
		GameData.base_coins += 100
		GameData.curr_coins = GameData.base_coins
		GameData.curr_souls -= GameData.increase_starting_coins_cost
		GameData.increase_starting_coins_cost += 10
		increase_starting_coins_cost_label.text = "%d" % GameData.increase_starting_coins_cost
		SignalBus.coin_collected.emit()
		SignalBus.soul_collected.emit()

func _on_incease_soul_drop_button_pressed() -> void:
	if GameData.curr_souls >= GameData.increase_soul_drop_cost:
		GameData.base_soul_drop_chance += 0.05
		GameData.curr_souls -= GameData.increase_soul_drop_cost
		GameData.increase_soul_drop_cost += 15
		increase_soul_drop_cost_label.text = "%d" % GameData.increase_soul_drop_cost
		SignalBus.soul_collected.emit()

func _on_increase_starting_health_button_pressed() -> void:
	if GameData.curr_souls >= GameData.increase_starting_health_cost:
		GameData.base_player_health += 10
		GameData.curr_player_health = GameData.base_player_health
		GameData.curr_souls -= GameData.increase_starting_health_cost
		GameData.increase_starting_health_cost += 10
		increase_starting_health_cost_label.text = "%d" % GameData.increase_starting_health_cost
		SignalBus.soul_collected.emit()


func _on_increase_potion_button_pressed() -> void:
	if GameData.curr_souls >= GameData.increase_potion_cost:
		GameData.curr_souls -= GameData.increase_potion_cost
		GameData.increase_potion_cost += 15
		incrase_potion_cost_label.text = "%d" % GameData.increase_potion_cost
		SignalBus.soul_collected.emit()
		
		GameData.base_health_potions += 1
		GameData.curr_health_potions += 1
		SignalBus.update_health_potion_hud.emit()
		if GameData.base_health_potions >= 3:
			$ColorRect/IncreasePotionButton.queue_free()


func _on_increase_dash_button_pressed() -> void:
	if GameData.curr_souls >= GameData.increase_dash_cost:
		GameData.curr_souls -= GameData.increase_dash_cost
		GameData.increase_dash_cost += 30
		increase_dash_cost_label.text = "%d" % GameData.increase_dash_cost
		SignalBus.soul_collected.emit()
		
		GameData.base_stamina += 100
		if GameData.base_stamina >= 300:
			$ColorRect/IncreaseDashButton.queue_free()
