extends CanvasLayer

@onready var encyclopedia = $Encyclopedia
var e_toggle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	encyclopedia.visible = false

func _input(event):
	pass
	#if event.is_action_pressed("encyclopedia"):
		#toggle_encyclopedia(!e_toggle)

### ENCYCLOPEDIA FUNCTIONS ###encyclopedia
func toggle_encyclopedia(toggle: bool):
	encyclopedia.visible = toggle
	get_tree().paused = toggle
	update_enemies($Encyclopedia/VBoxContainer/Characters/HBoxContainer/Goblin/Goblin/Goblin, "goblin")
	update_enemies($"Encyclopedia/VBoxContainer/Characters/HBoxContainer/Goblin Wizard/Goblin Wizard/Goblin Wizard", "goblinWizard")
	update_people($"Encyclopedia/VBoxContainer/Characters/HBoxContainer/Lady Luck/Lady Luck/Lady Luck", "ladyLuck")
	update_people($Encyclopedia/VBoxContainer/Characters/HBoxContainer/Shopkeeper/Shopkeeper/Shopkeeper, "shopkeeper")
	update_death($Encyclopedia/VBoxContainer/Characters/HBoxContainer/Death/Death/Death, "death")
	update_stats($Encyclopedia/VBoxContainer/TopRow/HBoxContainer/Stats/Stats/VBoxContainer)
	e_toggle = toggle
	
func update_enemies(node_path : Node, enemy_name : String):
	if Encyclopedia.characters[enemy_name].amount_killed > 0:
		node_path.get_child(0).texture = load(Encyclopedia.characters[enemy_name].image_path)
		node_path.get_child(1).text = Encyclopedia.characters[enemy_name].name
		node_path.get_child(2).text = "Type: " + Encyclopedia.characters[enemy_name].type
		node_path.get_child(3).text = Encyclopedia.characters[enemy_name].description
		node_path.get_child(4).text = "Total Killed: " + str(Encyclopedia.characters[enemy_name].amount_killed)

func update_death(node_path : Node, enemy_name : String):
	if Encyclopedia.characters[enemy_name].amount_killed > 0:
		node_path.get_child(0).texture = load(Encyclopedia.characters[enemy_name].image_path)
		node_path.get_child(1).text = Encyclopedia.characters[enemy_name].name
		node_path.get_child(2).text = "Type: " + Encyclopedia.characters[enemy_name].type
		node_path.get_child(3).text = Encyclopedia.characters[enemy_name].description
		node_path.get_child(4).text = "Hits taken: " + str(Encyclopedia.characters[enemy_name].amount_killed)

func update_people(node_path : Node, character : String):
	if character == "ladyLuck":
		if GameData.lady_luck_intro:
			node_path.get_child(0).texture = load(Encyclopedia.characters[character].image_path)
			node_path.get_child(1).text = Encyclopedia.characters[character].name
			node_path.get_child(2).text = "Type: " + Encyclopedia.characters[character].type
			node_path.get_child(3).text = Encyclopedia.characters[character].description
			node_path.get_child(4).text = Encyclopedia.characters[character].amount_killed
	if character == "shopkeeper":
		if GameData.shopkeeper_room_unlocked:
			node_path.get_child(0).texture = load(Encyclopedia.characters[character].image_path)
			node_path.get_child(1).text = Encyclopedia.characters[character].name
			node_path.get_child(2).text = "Type: " + Encyclopedia.characters[character].type
			node_path.get_child(3).text = Encyclopedia.characters[character].description
			node_path.get_child(4).text = Encyclopedia.characters[character].amount_killed

func update_stats(node_path : Node):
	node_path.get_child(1).text = "Total deaths: " + str(GameData.deaths)
	node_path.get_child(2).text = "Total # of kills: " + str(Encyclopedia.total_kills)
	node_path.get_child(3).text = "Most # of kills in a run: " + str(Encyclopedia.most_monsters_killed)
	node_path.get_child(4).text = "Current run kill count: " + str(Encyclopedia.current_kills)
	node_path.get_child(5).text = "Types of weapons encountered: " + str(len(Encyclopedia.weapons_collected)) + "/7"
	node_path.get_child(6).text = "Total rooms entered: " + str(Encyclopedia.rooms_entered)
