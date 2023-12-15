extends Node2D

@onready var map = $"../TileMap"
var astargrid : AStarGrid2D
var current_id_path: Array[Vector2i]
var current_id_pathv2: Array[Vector2i]
var target: Vector2
var is_moving: bool
var current_point_path: PackedVector2Array
var movement = 100
var make = false
var optionMove = false
func _ready() -> void:
	astargrid = AStarGrid2D.new()
	astargrid.region = map.get_used_rect()
	astargrid.cell_size = Vector2(64,64)
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	
	for x in map.get_used_rect().size.x:
		for y in map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + map.get_used_rect().position.x,
				y + map.get_used_rect().position.y)

			var tile_data = map.get_cell_tile_data(0, tile_position)

			if(tile_data == null or tile_data.get_custom_data("walkable") == false):
				astargrid.set_point_solid(tile_position)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		optionMove = true
		make = false
		is_moving = false
#	if event.is_action_pressed("click"):
#		make = true
	if event.is_action_pressed("aLeft"):
		make = true
	if event is InputEventMouse and is_moving == false:
		var id_path
		if is_moving:
			id_path = astargrid.get_id_path(
				map.local_to_map(global_position),
				map.local_to_map(get_global_mouse_position())			
			)
		else:
			id_path = astargrid.get_id_path(
				map.local_to_map(global_position),
				map.local_to_map(get_global_mouse_position())			
			)
			
	
		if id_path.is_empty() == false:
			current_id_path = id_path
#			current_point_path = astargrid.get_point_path(
#				map.local_to_map(global_position),
#				map.local_to_map(get_global_mouse_position())
#			)
		current_point_path = astargrid.get_point_path(
				map.local_to_map(global_position),
				map.local_to_map(get_global_mouse_position())
			)
		for i in current_point_path.size():
			current_point_path[i] = current_point_path[i] + Vector2(32,32)
		
signal DeleteLine
func _physics_process(delta: float) -> void:
	if current_id_path.is_empty():
		make = false
		return
	if make == true:
		if is_moving == false:
			target = map.map_to_local(current_id_path.front())
			is_moving = true
		
		if global_position == target and movement > 0:
			current_id_path.pop_front()
			movement -= 1
			print(movement)
			emit_signal("DeleteLine")
		
		if(movement >= 0):
			global_position = global_position.move_toward(target,10)
		else:
			make = false
			is_moving = false
			
		if current_id_path.is_empty() == false:
			target = map.map_to_local(current_id_path.front())
		else:
			is_moving = false
