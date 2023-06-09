extends Node2D
class_name Room

@onready var tilemap: TileMap = $TileMap
@onready var area: Area2D = $RoomArea

var exits: Array[String] = []
var unused_connections: Array[String]= ["north", "east", "south", "west"]
var is_active := false

const wall_tile_coords := Vector2i(0, 0)
const north_wall_tile_coords := Vector2i(1, 2)
const south_wall_tile_coords := Vector2i(1, 0)
const west_wall_tile_coords := Vector2i(2, 1)
const east_wall_tile_coords := Vector2i(0, 1)

const floor_tile_coords := Vector2i(4, 0)

func _ready():
	$ColorRect.visible = true

func get_shape():
	return $RoomArea/CollisionShape2D.shape.get_rect()

func get_size():
	return $RoomArea/CollisionShape2D.shape.get_rect().size

func _on_playable_area_entered(body):
	$ColorRect.visible = false
	SignalBus.player_enter.emit(get_instance_id())
	is_active = true

func _on_playable_area_exited(body):
	SignalBus.player_exit.emit(get_instance_id())
	is_active = false

func close_unused_connections():
	for connection in unused_connections:
		match(connection):
			"north":
				set_exit_tile(
					$NorthExit.position,
					Vector2i(0, 0),
					Vector2i(-1, 0),
					2,
					north_wall_tile_coords)
			"south":
				set_exit_tile(
					$SouthExit.position,
					Vector2i(0, -1),
					Vector2i(-1, -1),
					2,
					south_wall_tile_coords)
			"east":
				set_exit_tile(
					$EastExit.position,
					Vector2i(-1, -1),
					Vector2i(-1, 0),
					2,
					east_wall_tile_coords)
			"west":
				set_exit_tile(
					$WestExit.position,
					Vector2i(0, -1),
					Vector2i(0, 0),
					2,
					west_wall_tile_coords)

func set_exit_tile(tile_pos: Vector2, offset1: Vector2i, offset2: Vector2i, source_id: int, tile_coords):
	tilemap.set_cell(0, tilemap.local_to_map(tile_pos) + offset1, source_id, tile_coords)
	tilemap.set_cell(0, tilemap.local_to_map(tile_pos) + offset2, source_id, tile_coords)
