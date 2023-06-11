extends Node2D

@onready var spawn_points = $SpawnPoints.get_children()

var curr_enemies_in_room = 0
var column_tiles = [
	[
		Vector2i(-6, -4), Vector2i(-5, -4), Vector2i(-4, -4),
		Vector2i(-6, -3), Vector2i(-5, -3), Vector2i(-4, -3),
		Vector2i(-6, -2), Vector2i(-5, -2), Vector2i(-4, -2),
	],
	[
		Vector2i(3, -4), Vector2i(4, -4), Vector2i(5, -4),
		Vector2i(3, -3), Vector2i(4, -3), Vector2i(5, -3),
		Vector2i(3, -2), Vector2i(4, -2), Vector2i(5, -2)
	],
	[
		Vector2i(-5, 3), Vector2i(-4, 3),
		Vector2i(-5, 4), Vector2i(-4, 4)
	],
	[
		Vector2i(4, 3), Vector2i(5, 3),
		Vector2i(4, 4), Vector2i(5, 4),
		Vector2i(4, 5), Vector2i(5, 5)
	]
]

func _ready() -> void:
	SignalBus.enemy_dead.connect(_on_enemy_dead)
	SignalBus.boss_damaged.connect(_on_boss_damaged)
	SignalBus.boss_phase_change.connect(_on_boss_phase_change)
	SignalBus.boss_dead.connect(_on_boss_dead)

func _on_boss_phase_change(phase):
	if phase == 1:
		$AnimationPlayer.play("phase_0_1")
		var columns = RngUtils.array(column_tiles, 2, true)
		for column in columns:
			for tile in column:
				$TileMap.set_cell(0, tile, 1, Vector2(4, 0))
	elif phase == 2:
		$AnimationPlayer.play("phase_1_2")
		var column = RngUtils.array(column_tiles)[0]
		for tile in column:
			$TileMap.set_cell(0, tile, 1, Vector2(4, 0))

func _on_boss_damaged(curr_health):
	$CanvasLayer/ProgressBar.value = curr_health

func _on_enemy_dead():
	curr_enemies_in_room -= 1

func _on_boss_dead():
	$SpawnTimer.stop()

func _on_spawn_timer_timeout() -> void:
	try_spawning()

func try_spawning():
	if curr_enemies_in_room < 3:
		var chosen_point = RngUtils.array(spawn_points)[0]
		var roll = RngUtils.array_with_weighted(GameData.enemies, 1)[0]
		chosen_point.spawn(roll, spawn_points)
		curr_enemies_in_room += 1
