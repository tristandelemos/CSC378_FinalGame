extends Room

@onready var enemy = preload("res://instances/enemy.tscn")
@onready var spawn_points = $SpawnPoints.get_children()

var min_enemies: int = 1
var max_enemies: int = 1

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
	num_enemies -= 1
	if num_enemies <= 0:
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
	var num_to_spawn = RngUtils.int_range(min_enemies, max_enemies)
	num_enemies = num_to_spawn
	print(num_enemies)
	var chosen_spawn_points = RngUtils.array(spawn_points, num_to_spawn)
	for point in chosen_spawn_points:
		var enemy_instance = enemy.instantiate()
		enemy_instance.global_position = point.global_position
		get_tree().current_scene.call_deferred("add_child", enemy_instance)
