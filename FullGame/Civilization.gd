extends Node2D

@onready var camera = $Camera2D
@onready var map = $TileMap
@onready var labelSelectCastle = $LabelSelectCastle
@onready var popupMenu = $PopupMenuTest
@onready var knight = $Knight2
@onready var console = $Console/Text
@onready var path = $Path
@onready var currentPlayer = $PlayerVariables
@onready var turnButton = $"Console/New turn/Label"

#Granica mapy
var map_min = -20 * 64
var map_max = 20 * 64

var castle_scene_path = "res://Castle/Castle.tscn"
var knightScenePath = "res://army/Knight.tscn"
var tileSize = 64
var input_vector = Vector2()
var windowSize
var mousePosition

var turn = 1
var astargrid : AStarGrid2D
var current_id_path: Array[Vector2i]
var target: Vector2
var is_moving: bool
var current_point_path: PackedVector2Array
var movement = 100
var make = false
var optionMove = false


func _ready() -> void:
	map.createCastle.connect(_create_castle)
	windowSize = self.get_viewport_rect()
	RefreshTheHUD()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	mousePosition = get_local_mouse_position()
	if event is InputEventMouse and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#popupMenu.popup(Rect2i(get_window().get_mouse_position().x,get_window().get_mouse_position().y+300,100,100))
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
	knightNode.connect("SelectNodeToCreatePath",_on_knight_select_node_to_create_path)
	knightNode.connect("GetLocalTileMap",map._on_knight_get_local_tile_map)
	knightNode.connect("DeleteLine",path._on_knight_delete_line)
	knightNode.connect("CreateCastle",_on_knight_create_castle)
	camera.input_vector = knightPosition
	console.text += knightNode.player + " stworzył rycerza \n"
	pass # Replace with function body.

func _on_knight_create_castle() -> void:
	if map.get_cell_alternative_tile(2,map.localTile) != 0 and map.get_cell_alternative_tile(4,map.localTile) != 0:
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
		currentPlayer.castleFields.push_back(castle_node)
		map.set_cell(4,map.localTile,2,Vector2i(0,7))
	else:
		console.text += "Nie można utworzyć tutaj zamku"
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



func _on_knight_select_node_to_create_path(knightNode) -> void:
	path.player = knightNode
	pass # Replace with function body.


func _on_knight_2_create_farm() -> void:
	if map.get_cell_alternative_tile(2,map.localTile) != 0 and map.get_cell_alternative_tile(4,map.localTile) != 0 and currentPlayer.food >= 2 and currentPlayer.gold >=1:
		map.set_cell(2,map.localTile,2,Vector2i(2,2))
		currentPlayer.foodFields.push_back([map.localTile,7])
		currentPlayer.food -= 2
		currentPlayer.gold -= 1
		RefreshTheHUD()
	elif currentPlayer.food < 2 or currentPlayer.gold < 1:
		console.text += "Nie masz wystarczająco surowców"
	else:
		console.text += "Nie można utworzyć tutaj farmy"
	RefreshTheHUD()
	pass 
	
#To dotyczy kiedy nastapi nowa tura
func _RefreshVariableOnTurn() -> void:
	turnButton.text = str(turn)
	RefreshFarmTileOnCurrentPlayer()
	RefreshCastleFarms()
	RefreshTheHUD()
	turn += 1
	pass
	
func RefreshFarmTileOnCurrentPlayer():
	for farm in currentPlayer.foodFields:
		farm[1] -= 1
		if(farm[1] == 5):
			map.set_cell(2,farm[0],-1)
			map.set_cell(3,farm[0],2,Vector2i(1,2))
		elif(farm[1] == 0):
			map.set_cell(3,farm[0],-1)

func RefreshCastleFarms():
	var foodTemp = 0
	for farm in currentPlayer.castleFields:
		foodTemp += farm.RefreshTheFoodIncome()
	currentPlayer.food += foodTemp

func RefreshTheHUD():
	currentPlayer.foodValue.text = str(currentPlayer.food)
	currentPlayer.goldValue.text = str(currentPlayer.gold)
