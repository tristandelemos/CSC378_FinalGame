extends Sprite2D

@onready var label := $Label

@export var dialogue: DialogueResource

func _ready() -> void:
	if GameData.deaths <= 0:
		visible = false
		$PlayerDetector/CollisionShape2D.disabled = true
	else:
		visible = true
		$PlayerDetector/CollisionShape2D.disabled = false
	label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and label.visible and (not GameData.freeze_player or GameData.lady_luck_intro):
		talk()

func _on_player_detector_body_entered(body: Node2D) -> void:
	label.visible = true

func _on_player_detector_body_exited(body: Node2D) -> void:
	label.visible = false

func talk():
	if not GameData.lady_luck_intro:
		GameData.freeze_player = true
		DialogueManager.show_example_dialogue_balloon(dialogue)
	else:
		GameData.freeze_player = not GameData.freeze_player
		$LadyLuckShop.visible = not $LadyLuckShop.visible
