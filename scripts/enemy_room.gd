extends Room

@onready var enemies: Array[Dictionary] = [
	{
		"value": preload("res://instances/enemy.tscn"),
		"type": "goblin",
		"weight": 10.0
	},
	{
		"value": preload("res://instances/goblin_wizard.tscn"),
		"type": "goblin_wizard",
		"weight": 90.0
	},
]
@onready var spawn_points = $SpawnPoints.get_children()

var unexplored := true
var num_enemies := 0

func _ready():
	super._ready()
	SignalBus.enemy_dead.connect(_on_enemy_dead)

func _on_playable_area_entered(body):
	super._on_playable_area_entered(body)
	if unexplored:
		spawn_enemies()
		lock_room()
		unexplored = false

func _on_enemy_dead():
	if is_active:
		num_enemies -= 1
		if num_enemies <= 0:
			GameData.increase_difficulty()
			unlock_room()

func lock_room():
	for exit in exits:
		match(exit):
			"north":
				set_exit_tile(
					$NorthExit.position,
					Vector2i(0, 0),
					Vector2i(-1, 0),
					wall_tile_coords)
			"south":
				set_exit_tile(
					$SouthExit.position,
					Vector2i(0, -1),
					Vector2i(-1, -1),
					wall_tile_coords)
			"east":
				set_exit_tile(
					$EastExit.position,
					Vector2i(-1, -1),
					Vector2i(-1, 0),
					wall_tile_coords)
			"west":
				set_exit_tile(
					$WestExit.position,
					Vector2i(0, -1),
					Vector2i(0, 0),
					wall_tile_coords)

func unlock_room():
	for exit in exits:
		match(exit):
			"north":
				set_exit_tile(
					$NorthExit.position,
					Vector2i(0, 0),
					Vector2i(-1, 0),
					floor_tile_coords)
			"south":
				set_exit_tile(
					$SouthExit.position,
					Vector2i(0, -1),
					Vector2i(-1, -1),
					floor_tile_coords)
			"east":
				set_exit_tile(
					$EastExit.position,
					Vector2i(-1, -1),
					Vector2i(-1, 0),
					floor_tile_coords)
			"west":
				set_exit_tile(
					$WestExit.position,
					Vector2i(0, -1),
					Vector2i(0, 0),
					floor_tile_coords)

func spawn_enemies():
	var num_to_spawn = RngUtils.int_range(GameData.curr_min_enemy_spawn, GameData.curr_max_enemy_spawn)
	num_enemies = num_to_spawn
	var chosen_spawn_points = RngUtils.array(spawn_points, num_to_spawn)
	for point in chosen_spawn_points:
		var roll = RngUtils.array_with_weighted(enemies, 1)[0]
		var enemy_instance = roll["value"].instantiate()
		if roll["type"] == "goblin_wizard":
			enemy_instance.spawn_points = spawn_points
		enemy_instance.global_position = point.global_position
		get_tree().current_scene.call_deferred("add_child", enemy_instance)
