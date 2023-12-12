extends TileMap

@onready var tileMap : TileMap = $"."
@onready var popupMap = $"PopupMenu"
const Enums = preload("res://map/EnumsPopup.gd") 
var mouse_positon
var local_position = Vector2(0,0)
var openPopup = false

signal Move(vector2)
signal Attack(vector2)

func _ready() -> void:
	popupMap.visible = false
	
	pass # Replace with function body.


func _input(event):  
	mouse_positon = get_global_mouse_position()
	var position = tileMap.local_to_map(Vector2(mouse_positon.x,mouse_positon.y))
	local_position = position
	if(event.is_action_pressed("click")):
		position = tileMap.local_to_map(Vector2(mouse_positon.x,mouse_positon.y))
		#print(position)
		local_position = position
		
	if(event.is_action_pressed("right_click") and event.is_pressed()):
		position = tileMap.local_to_map(Vector2(mouse_positon.x,mouse_positon.y))
		var xd = tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y))
		#print(tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y)))
		if(tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y)) == Vector2i(0,0)): #water
			popupMap.clear()
			popupMap.reset_size()
			popupMap.add_item("Create fish", Enums.popUpsWater.CREATE_FISH)
			popupMap.add_item("Create ship", Enums.popUpsWater.Create_ship)
			popupMap.add_item("Sey Hi", Enums.popUpsWater.sey_Hi)
		elif(tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y)) == Vector2i(0,1)): #desert
			popupMap.clear()
			popupMap.reset_size()
			popupMap.add_item("Create desert", Enums.popUpsDesert.CREATE_DESERT)
			popupMap.add_item("Exit", Enums.popUpsDesert.Exit)
		elif(tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y)) == Vector2i(1,0)): #forest
			popupMap.clear()
			popupMap.reset_size()
			popupMap.add_item("Create farm", Enums.popUpsGrass.CREATE_FARM)
			popupMap.add_item("Create wheat", Enums.popUpsGrass.CREATE_WHEAT)
			popupMap.add_item("Create fill", Enums.popUpsGrass.Fill)
		elif(tileMap.get_cell_atlas_coords(0,Vector2i(position.x,position.y)) == Vector2i(1,1)): #grass
			popupMap.clear()
			popupMap.reset_size()
			popupMap.add_item("Create woods", Enums.popUpsForest.CREATE_WOOD)
			popupMap.add_item("Exit", Enums.popUpsForest.Exit)
		else:
			popupMap.clear() 

		var openPopup = true
		popupMap.visible = openPopup
		popupMap.add_item("Move")
		popupMap.popup(Rect2(mouse_positon.x,mouse_positon.y,popupMap.size.x,popupMap.size.y))



func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		0:
			print("attack")
			emit_signal("Attack",local_position)
		1:
			print("jeden")
		2:
			print("dwa")
		3:
			emit_signal("Move",local_position)
		4: 
			print("cztery")
	pass # Replace with function body.

	pass # Replace with function body.
