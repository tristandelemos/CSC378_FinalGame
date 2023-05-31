extends CanvasLayer
class_name HUD

@onready var minimap = $Minimap
@onready var minirooms = $Minimap/MiniRooms

func _ready() -> void:
    $Minimap.visible = false
    SignalBus.player_enter.connect(_on_player_enter)
    SignalBus.player_exit.connect(_on_player_exit)
    SignalBus.update_weapon_slot.connect(update_weapon_slot)
    update_weapon_slot(GameData.curr_player_weapon)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("minimap"):
        minimap.visible = true
    if event.is_action_released("minimap"):
        minimap.visible = false

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
