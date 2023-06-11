extends Area2D
class_name Loot

var weapon: GameData.Weapon = -1

func _ready():
	$InteractLabel.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and $InteractLabel.visible:
		interact()

func setup():
	if weapon < 0:
		weapon = GameData.Weapon.values()[RngUtils.global_rng.randi_range(1, len(GameData.Weapon.values()) - 1)]
	$LootSprite.texture = GameData.get_weapon_sprite(weapon)

func interact() -> void:
	SignalBus.update_weapon_slot.emit(weapon)
	SignalBus.drop_current_weapon.emit()
	GameData.curr_player_weapon = weapon
	if weapon not in Encyclopedia.weapons_collected:
		Encyclopedia.weapons_collected.append(weapon)
	queue_free()

func set_loot_sprite(sprite):
	$LootSprite.texture = sprite

func _on_body_entered(body: Node2D) -> void:
	$InteractLabel.visible = true

func _on_body_exited(body: Node2D) -> void:
	$InteractLabel.visible = false
