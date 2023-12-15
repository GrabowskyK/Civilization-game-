extends Node2D

@onready var camera = $Camera2D
@onready var map = $TileMap
@onready var labelSelectCastle = $LabelSelectCastle
@onready var popupMenu = $PopupMenuTest
@onready var knight = $Knight
@onready var console = $Console/Text

#Granica mapy
var map_min = -20 * 64
var map_max = 20 * 64

var castle_scene_path = "res://Castle/Castle.tscn"
var knightScenePath = "res://army/Knight.tscn"
var tileSize = 64
var input_vector = Vector2()
var windowSize
var mousePosition


func _ready() -> void:
	map.createCastle.connect(_create_castle)
	windowSize = self.get_viewport_rect()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	mousePosition = get_local_mouse_position()
	if event is InputEventMouse and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#popupMenu.popup(Rect2i(get_window().get_mouse_position().x,get_window().get_mouse_position().y,100,100))
		pass

func _create_castle(vector2):
	vector2.x = vector2.x * tileSize + tileSize/2
	vector2.y = vector2.y * tileSize + tileSize/2
	var castle_scene = load(castle_scene_path)
	var castle_node = castle_scene.instantiate()
	castle_node.position = vector2
	add_child(castle_node)
	#camera.position = castle_node.position
	labelSelectCastle.queue_free()
	pass
#


func _on_castle_set_camera_in_castle(value1) -> void:
	camera.input_vector = value1
	pass # Replace with function body.

func _on_popup_menu_test_create_castle_frompopup() -> void: #Tworzenie zamku
#	var castlePosition : Vector2 = Vector2(0,0)
#	castlePosition.x =  map.localTile.x * tileSize + tileSize/2
#	castlePosition.y =  map.localTile.y * tileSize + tileSize/2
#	var castle_scene = load(castle_scene_path)
#	var castle_node = castle_scene.instantiate()
#	castle_node.position = castlePosition
#	add_child(castle_node)
#	camera.input_vector = castlePosition
#	console.text += "Stworzono zamek \n"
	pass # Replace with function body.



func _on_popup_menu_test_create_knight_frompopup() -> void:
	var knightPosition : Vector2 = Vector2(0,0)
	knightPosition.x =  map.localTile.x * tileSize + tileSize/2
	knightPosition.y =  map.localTile.y * tileSize + tileSize/2
	var knightScene = load(knightScenePath)
	var knightNode = knightScene.instantiate()
	knightNode.position = knightPosition
	knightNode.setStats(10,10,10, "Gracz B")
	add_child(knightNode)
	camera.input_vector = knightPosition
	console.text += knightNode.player + " stworzył rycerza \n"
	pass # Replace with function body.


func _on_knight_create_castle() -> void:
	var castlePosition : Vector2 = Vector2(0,0)
	castlePosition.x =  map.localTile.x * tileSize + tileSize/2
	castlePosition.y =  map.localTile.y * tileSize + tileSize/2
	var castle_scene = load(castle_scene_path)
	var castle_node = castle_scene.instantiate()
	castle_node.position = castlePosition
	castle_node.castleName = randomCastleName()
	print(castle_node.castleName)
	add_child(castle_node)
	camera.input_vector = castlePosition
	console.text += "Stworzono zamek \n"
	pass # Replace with function body.
	pass # Replace with function body.


var exampleCities : Array = [
	"Katowice",
	"Gliwice",
	"Sosnowiec",
	"Zabrze",
	"Bytom",
	"Ruda Śląska",
	"Tychy",
	"Dąbrowa Górnicza",
	"Chorzów",
	"Jaworzno",
	"Mysłowice",
	"Siemianowice Śląskie",
	"Świętochłowice",
	"Czeladź",
	"Knurów",
	"Piekary Śląskie",
	"Częstochowa"
]
func randomCastleName() -> String: #Tutaj może wyrzucać bład
	if exampleCities.size() > 0:
		var randomNumber = randi() % exampleCities.size()
		var randomName = exampleCities[randomNumber]
		exampleCities.pop_at(randomNumber)
		return randomName
	else:
		return "nazwa"

