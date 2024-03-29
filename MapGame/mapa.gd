extends TileMap
var cameraSpeed = 200

@onready var TileSelectMaterial = load("res://MapGame/TileSelectMaterial.material")

var currentZoom
var input_vector = Vector2()
var dragCamera = false
var drag_start = Vector2()
var mouse_position
var positionClickedTile
var clickedTilePos2
var isFirstCastleCreated : bool = false
var localTile : Vector2 = Vector2(0,0) #Służy do pobierania kliknietego kafelka 

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	TileSelectMaterial.set_shader_parameter("globalMousePosition", get_global_mouse_position())
	mouse_position = get_global_mouse_position()
	positionClickedTile = self.local_to_map(Vector2(mouse_position.x,mouse_position.y))
	pass
	
func _input(event: InputEvent):
	if(event.is_action_pressed("right_click")):
		mouse_position = get_global_mouse_position()
		positionClickedTile = self.local_to_map(Vector2(mouse_position.x,mouse_position.y))
	
	if(event.is_action_pressed("click")):
		mouse_position = get_global_mouse_position()
		print(self.local_to_map(Vector2(mouse_position.x,mouse_position.y)))


func _on_popup_menu_test_get_local_tile_map() -> void:
	mouse_position = get_global_mouse_position()
	localTile =  self.local_to_map(Vector2(mouse_position.x, mouse_position.y))

func _on_knight_get_local_tile_map() -> void:
	mouse_position = get_global_mouse_position()
	localTile =  self.local_to_map(Vector2(mouse_position.x, mouse_position.y))
	pass # Replace with function body.
