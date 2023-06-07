extends Sprite2D

@onready var shop_ui = $ShopUI
@onready var interact_label = $Label
@onready var slots: Array[Node] = $ShopUI/Slots.get_children()

func _ready() -> void:
	interact_label.visible = false
	shop_ui.visible = false

func _process(delta: float) -> void:
	for slot in slots:
		if GameData.curr_coins > slot.cost:
			slot.green_text()
		else:
			slot.red_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interact_label.visible:
			GameData.freeze_player = not GameData.freeze_player
			shop_ui.visible = not shop_ui.visible

func _on_player_detector_body_entered(body: Node2D) -> void:
	interact_label.visible = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	interact_label.visible = false
