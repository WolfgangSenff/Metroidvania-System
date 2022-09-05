@tool
extends Node2D

var rooms: Array[Vector3i]
var initialized: bool

var min_room := Vector2i(999999, 999999)
var max_room := Vector2i(-999999, -999999)

func _enter_tree() -> void:
	if initialized:
		return
	initialized = true
	
	if Engine.is_editor_hint():
		MetroidvaniaSystem.reload_data()
	else:
		MetroidvaniaSystem.current_map = self
	
	var owner_node := owner if owner != null else self
	rooms = MetroidvaniaSystem.assigned_maps.get(owner_node.scene_file_path, [])
	if rooms.is_empty():
		return
	
	for p in rooms:
		min_room.x = mini(min_room.x, p.x)
		min_room.y = mini(min_room.y, p.y)
		max_room.x = maxi(max_room.x, p.x)
		max_room.y = maxi(max_room.y, p.y)

func adjust_camera(camera: Camera2D):
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = (max_room.x - min_room.x + 1) * MetroidvaniaSystem.in_game_room_size.x
	camera.limit_bottom = (max_room.y - min_room.y + 1) * MetroidvaniaSystem.in_game_room_size.y

func _draw() -> void:
	if not Engine.is_editor_hint() or rooms.is_empty():
		return
	
	for p in rooms:
		var coord := Vector2(p.x - min_room.x, p.y - min_room.y)
		draw_rect(Rect2(coord * MetroidvaniaSystem.in_game_room_size, MetroidvaniaSystem.in_game_room_size), Color.WHITE, false, 2)
