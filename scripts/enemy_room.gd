extends Node2D
class_name Room

@onready var tilemap = $TileMap
@onready var area = $RoomArea

var unused_connections := ["north", "east", "south", "west"]

const wall_tile_coords := Vector2i(0, 0)

func get_shape():
	return $RoomArea/CollisionShape2D.shape.get_rect()

func get_size():
	return $RoomArea/CollisionShape2D.shape.get_rect().size

func close_unused_connections():
	for connection in unused_connections:
		match(connection):
			"north":
				tilemap.set_cell(0, tilemap.local_to_map($NorthExit.position), 0, wall_tile_coords)
				tilemap.set_cell(0, tilemap.local_to_map($NorthExit.position) + Vector2i(-1, 0), 0, wall_tile_coords)
			"south":
				tilemap.set_cell(0, tilemap.local_to_map($SouthExit.position) + Vector2i(0, -1), 0, wall_tile_coords)
				tilemap.set_cell(0, tilemap.local_to_map($SouthExit.position) + Vector2i(-1, -1), 0, wall_tile_coords)
			"east":
				tilemap.set_cell(0, tilemap.local_to_map($EastExit.position) + Vector2i(-1, -1), 0, wall_tile_coords)
				tilemap.set_cell(0, tilemap.local_to_map($EastExit.position) + Vector2i(-1, 0), 0, wall_tile_coords)
			"west":
				tilemap.set_cell(0, tilemap.local_to_map($WestExit.position) + Vector2i(0, -1), 0, wall_tile_coords)
				tilemap.set_cell(0, tilemap.local_to_map($WestExit.position), 0, wall_tile_coords)
