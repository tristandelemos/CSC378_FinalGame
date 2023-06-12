extends Room

@onready var spawn_points = $SpawnPoints.get_children()

var unexplored := true
var num_enemies := 0
var waves_left = GameData.base_waves

func _ready():
	super._ready()
	SignalBus.enemy_dead.connect(_on_enemy_dead)

func _on_playable_area_entered(body):
	super._on_playable_area_entered(body)
	if unexplored:
		Encyclopedia.rooms_entered += 1
		SignalBus.fight_start.emit()
		spawn_enemies()
		lock_room()
		unexplored = false

func _on_enemy_dead():
	if is_active:
		num_enemies -= 1
		if num_enemies <= 0:
			if waves_left > 0:
				spawn_enemies()
			else:
				SignalBus.fight_end.emit()
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
					0,
					wall_tile_coords)
			"south":
				set_exit_tile(
					$SouthExit.position,
					Vector2i(0, -1),
					Vector2i(-1, -1),
					0,
					wall_tile_coords)
			"east":
				set_exit_tile(
					$EastExit.position,
					Vector2i(-1, -1),
					Vector2i(-1, 0),
					0,
					wall_tile_coords)
			"west":
				set_exit_tile(
					$WestExit.position,
					Vector2i(0, -1),
					Vector2i(0, 0),
					0,
					wall_tile_coords)

func unlock_room():
	for exit in exits:
		match(exit):
			"north":
				set_exit_tile(
					$NorthExit.position,
					Vector2i(0, 0),
					Vector2i(-1, 0),
					1,
					floor_tile_coords)
			"south":
				set_exit_tile(
					$SouthExit.position,
					Vector2i(0, -1),
					Vector2i(-1, -1),
					1,
					floor_tile_coords)
			"east":
				set_exit_tile(
					$EastExit.position,
					Vector2i(-1, -1),
					Vector2i(-1, 0),
					1,
					floor_tile_coords)
			"west":
				set_exit_tile(
					$WestExit.position,
					Vector2i(0, -1),
					Vector2i(0, 0),
					1,
					floor_tile_coords)

func spawn_enemies():
	waves_left -= 1
	var num_to_spawn = RngUtils.int_range(GameData.curr_min_enemy_spawn, GameData.curr_max_enemy_spawn)
	num_enemies = num_to_spawn
	var chosen_spawn_points = RngUtils.array(spawn_points.duplicate(), num_to_spawn, true)
	for point in chosen_spawn_points:
		var roll = RngUtils.array_with_weighted(GameData.enemies, 1)[0]
		point.spawn(roll, spawn_points)
		await get_tree().create_timer(0.1).timeout
