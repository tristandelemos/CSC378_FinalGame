extends Node2D

@onready var rooms: Array[Dictionary] = [
    {
        "type": "enemy",
        "resource": preload("res://instances/rooms/enemy_room_one.tscn")
    },
    {
        "type": "enemy",
        "resource": preload("res://instances/rooms/enemy_room_two.tscn")
    },
    {
        "type": "enemy",
        "resource": preload("res://instances/rooms/enemy_room_three.tscn")
    },
    {
        "type": "loot",
        "resource": preload("res://instances/rooms/loot_room_one.tscn")
    }]
#@onready var exit_room = preload("res://room_exit.tscn")
#@onready var slot := preload("res://room_slot.tscn")
@onready var mini_room := preload("res://instances/mini_room.tscn")
@onready var start_room := $Rooms/StartRoom
@onready var hud: HUD = get_tree().current_scene.get_node("Player/HUD")
@onready var minimap := get_tree().current_scene.get_node("Player/HUD/Minimap")
@onready var minirooms := get_tree().current_scene.get_node("Player/HUD/Minimap/MiniRooms")
@onready var connections := get_tree().current_scene.get_node("Player/HUD/Minimap/Connections")

@export var min_rooms := 7
@export var max_rooms := 10

var curr_num_rooms = 0

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("generate"):
        get_tree().reload_current_scene()

func _ready() -> void:
    generate()

func walk() -> Array:
    var cardinal_directions = ["N", "S", "E", "W"]
    var path: Array = RngUtils.array(cardinal_directions, 30)
    return path

func generate() -> void:
    var path: Array = walk()
    place_rooms(path)
    # add_exit_room()
    close_empty_room_connections()

func place_rooms(path) -> void:
    var prev_room: Room = start_room
    var prev_room_pos := Vector2(0, 0)
    var prev_mini_room = minirooms.get_node("SafeMiniRoom")
    prev_mini_room.room = start_room.get_instance_id()    
    var occupied
    for direction in path:
        occupied = position_occupied(direction, prev_room_pos, prev_room)
        if len(occupied) <= 0:
            prev_room = add_new_room(direction, prev_room, prev_room_pos)
            prev_mini_room = update_minimap(direction, prev_mini_room, prev_room.get_instance_id())
            prev_room_pos = prev_room.global_position
            curr_num_rooms += 1
            if curr_num_rooms >= max_rooms:
                break
        else:
            update_unused_connections(direction, prev_room, occupied[0])
            prev_room = occupied[0]
            prev_room_pos = occupied[0].global_position
            var new_miniroom = hud.find_miniroom(prev_room.get_instance_id())
            add_minimap_connection(prev_mini_room.position, new_miniroom.position)
            prev_mini_room = new_miniroom

#func add_exit_room():
#	var farthest_room = get_farthest_room()
#	var exit_room_instance: Room = exit_room.instantiate()
#	var exit_direction = RngUtils.array(farthest_room.unused_connections)[0]
#	var mini_room_instance
#	match(exit_direction):
#		"north":
#			exit_room_instance.global_position = \
#				Vector2(farthest_room.global_position.x, farthest_room.global_position.y - farthest_room.get_size().y)
#			farthest_room.unused_connections.pop_at(farthest_room.unused_connections.find("north"))
#			exit_room_instance.unused_connections.pop_at(exit_room_instance.unused_connections.find("south"))
#		"south":
#			exit_room_instance.global_position = \
#				Vector2(farthest_room.global_position.x, farthest_room.global_position.y + farthest_room.get_size().y)
#			farthest_room.unused_connections.pop_at(farthest_room.unused_connections.find("south"))
#			exit_room_instance.unused_connections.pop_at(exit_room_instance.unused_connections.find("north"))
#		"east":
#			exit_room_instance.global_position = \
#				Vector2(farthest_room.global_position.x + farthest_room.get_size().x, farthest_room.global_position.y)
#			farthest_room.unused_connections.pop_at(farthest_room.unused_connections.find("east"))
#			exit_room_instance.unused_connections.pop_at(exit_room_instance.unused_connections.find("west"))
#		"west":
#			exit_room_instance.global_position = \
#				Vector2(farthest_room.global_position.x - farthest_room.get_size().x, farthest_room.global_position.y)
#			farthest_room.unused_connections.pop_at(farthest_room.unused_connections.find("west"))
#			exit_room_instance.unused_connections.pop_at(exit_room_instance.unused_connections.find("east"))
#	$Rooms.add_child(exit_room_instance)

func get_farthest_room() -> Room:
    var farthest_room: Room = start_room
    var farthest_distance = 0
    var curr_dist
    var curr_rooms: Array = $Rooms.get_children()
    for room in curr_rooms:
        curr_dist = start_room.global_position.distance_to(room.global_position)
        if curr_dist > farthest_distance:
            farthest_room = room
            farthest_distance = curr_dist
    return farthest_room

func add_new_room(direction, prev_room, prev_room_pos):
    var chosen_room = RngUtils.array(rooms)[0]
    if chosen_room["type"] == "loot":
        rooms.pop_at(rooms.find(chosen_room))
    var room_instance: Room = chosen_room["resource"].instantiate()
    match(direction):
        "N":
            room_instance.global_position = Vector2(prev_room_pos.x, prev_room_pos.y - prev_room.get_size().y)
            prev_room.exits.append("north")
            room_instance.exits.append("south")
            prev_room.unused_connections.pop_at(prev_room.unused_connections.find("north"))
            room_instance.unused_connections.pop_at(room_instance.unused_connections.find("south"))
        "S":
            room_instance.global_position = Vector2(prev_room_pos.x, prev_room_pos.y + prev_room.get_size().y)
            prev_room.exits.append("south")
            room_instance.exits.append("north")
            prev_room.unused_connections.pop_at(prev_room.unused_connections.find("south"))
            room_instance.unused_connections.pop_at(room_instance.unused_connections.find("north"))
        "E":
            room_instance.global_position = Vector2(prev_room_pos.x + prev_room.get_size().x, prev_room_pos.y)
            prev_room.exits.append("east")
            room_instance.exits.append("west")
            prev_room.unused_connections.pop_at(prev_room.unused_connections.find("east"))
            room_instance.unused_connections.pop_at(room_instance.unused_connections.find("west"))
        "W":
            room_instance.global_position = Vector2(prev_room_pos.x - prev_room.get_size().x, prev_room_pos.y)
            prev_room.exits.append("west")
            room_instance.exits.append("east")
            prev_room.unused_connections.pop_at(prev_room.unused_connections.find("west"))
            room_instance.unused_connections.pop_at(room_instance.unused_connections.find("east"))
    $Rooms.add_child(room_instance)
    return room_instance

func update_minimap(direction, prev_mini_room, room):
    var mini_room_instance = mini_room.instantiate()
    mini_room_instance.room = room
    minirooms.add_child(mini_room_instance)
    match(direction):
        "N":
            mini_room_instance.position = prev_mini_room.position + Vector2(0, -64)
        "S":
            mini_room_instance.position = prev_mini_room.position + Vector2(0, 64)
        "E":
            mini_room_instance.position = prev_mini_room.position + Vector2(64, 0)
        "W":
            mini_room_instance.position = prev_mini_room.position + Vector2(-64, 0)
    add_minimap_connection(prev_mini_room.position, mini_room_instance.position)
    return mini_room_instance

func add_minimap_connection(p1: Vector2, p2: Vector2):
    var line: Line2D = Line2D.new()
    line.width = 3
    line.add_point(p1 + Vector2(24, 24))
    line.add_point(p2 + Vector2(24, 24))
    connections.add_child(line)

func update_unused_connections(direction, prev_room, target):
    var prev_index
    var target_index
    match(direction):
        "N":
            prev_index = prev_room.unused_connections.find("north")
            target_index = target.unused_connections.find("south")
        "S":
            prev_index = prev_room.unused_connections.find("south")
            target_index = target.unused_connections.find("north")
        "E":
            prev_index = prev_room.unused_connections.find("east")
            target_index = target.unused_connections.find("west")
        "W":
            prev_index = prev_room.unused_connections.find("west")
            target_index = target.unused_connections.find("east")
    if prev_index >= 0:
        prev_room.unused_connections.pop_at(prev_index)
    if target_index >= 0:
        target.unused_connections.pop_at(target_index)

func close_empty_room_connections() -> void:
    var curr_rooms: Array = $Rooms.get_children()
    for room in curr_rooms:
        room.close_unused_connections()

func position_occupied(direction, prev_room_pos, prev_room):
    var occupied
    match(direction):
        "N":
            occupied = position_occupied_helper(Vector2(prev_room_pos.x, prev_room_pos.y - prev_room.get_size().y))
        "S":
            occupied = position_occupied_helper(Vector2(prev_room_pos.x, prev_room_pos.y + prev_room.get_size().y))
        "E":
            occupied = position_occupied_helper(Vector2(prev_room_pos.x + prev_room.get_size().x, prev_room_pos.y))
        "W":
            occupied = position_occupied_helper(Vector2(prev_room_pos.x - prev_room.get_size().x, prev_room_pos.y))
    return occupied

func position_occupied_helper(pos: Vector2) -> Array:
    var curr_rooms: Array = $Rooms.get_children()
    for room in curr_rooms:
        if room.global_position == pos:
            return [room]
    return []
