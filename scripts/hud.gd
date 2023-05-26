extends CanvasLayer
class_name HUD

@onready var minimap = $Minimap
@onready var minirooms = $Minimap/MiniRooms

func _ready() -> void:
    $Minimap.visible = false
    SignalBus.player_enter.connect(_on_player_enter)
    SignalBus.player_exit.connect(_on_player_exit)

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

func show_minimap():
    minimap.visible = true

func hide_minimap():
    minimap.visible = false
