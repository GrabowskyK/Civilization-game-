extends Node2D

@onready var camera = $Camera2D
@onready var map = $TileMap
@onready var labelSelectCastle = $LabelSelectCastle
@onready var knight = $Knight2
@onready var console = $Console/Text
@onready var path = $Path
@onready var currentPlayer = $PlayerVariables
@onready var turnButton = $Console/UI/MarginContainer/VBoxContainer/Day

var playerVariablePath = ""
#var players : Array = [ PlayerClass.new(), PlayerClass.new(), PlayerClass.new()]
var players : Array = []

#Granica mapy
var map_min = -20 * 64
var map_max = 20 * 64

var castle_scene_path = "res://Castle/Castle.tscn"
var knightScenePath = "res://army/Knight.tscn"
var unitScenePath = "res://TypeArmy/SingleCharacter.tscn"
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
var lockZooming = true #Do blokowania oddalania/przybliżania kamery gdy potrzeba (np. panele)

@onready var delete = $Knight3
func _ready() -> void:
	for i in range(0,GlobalVariables.flags.size(),1):
			var newPlayer = PlayerClass.new()
			newPlayer.playerFlag = GlobalVariables.flags[i]
			newPlayer.playerName = GlobalVariables.names[i]
			players.append(newPlayer)
	StartGame()
	setCurrentPlayerNextPlayer(players[0])
	var result = currentPlayer
	knight.player = currentPlayer
	windowSize = self.get_viewport_rect()
	RefreshTheHUD()
	pass # Replace with function body.

func StartGame():
	var jednostkaPath = load("res://TypeArmy/SingleCharacter.tscn")
	var castle_scene = load("res://Castle/Castle.tscn")
	var sizeMap = map.get_used_rect()
	var castlePosition : Vector2 = Vector2(0,0)
	var ArrayPosition : Array = [Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1),Vector2(1,1)]
	for i in range(0,players.size(),1):
		castlePosition.x =  ArrayPosition[i].x * sizeMap.size.x/4 * tileSize + tileSize/2
		castlePosition.y =  ArrayPosition[i].y * sizeMap.size.y/4 * tileSize + tileSize/2
		var tile_data = map.get_cell_tile_data(0, map.local_to_map(castlePosition))
		if(tile_data.get_custom_data("walkable") == true):		
			var castle_node = castle_scene.instantiate()
			castle_node.position = castlePosition
			castle_node.castleName = randomCastleName()
			castle_node.player = players[i]
			add_child(castle_node)
			castle_node.connect("CreateJednostka_v3",_CreateJednostkaFromCastle)
			#camera.input_vector = castlePosition
			players[i].castleFields.push_back(castle_node)
			#map.set_cell(4,castlePosition,2,Vector2i(0,7))
			players[i].castles.append(castle_node)
		else:
			#Ta funkcja jest źle zrobiona ale nie chce tracic czasu
			var k = 1
			while(tile_data.get_custom_data("walkable") == false):
				castlePosition.x = (sizeMap.size.x/4 * (tileSize + k) + tileSize/2) 
				castlePosition.y = (sizeMap.size.y/4 * (tileSize + k) + tileSize/2)
				k += 1
		var jednostkaNode = jednostkaPath.instantiate()
		jednostkaNode.connect("GetLocalTileMap",map._on_knight_get_local_tile_map)
		jednostkaNode.connect("DeleteLine",path._on_knight_delete_line)
		jednostkaNode.connect("SelectNodeToCreatePath",_on_knight_select_node_to_create_path)
		jednostkaNode.connect("CreateFarm",_on_knight_2_create_farm)
		jednostkaNode.connect("CreateCastle",_on_knight_create_castle)
		jednostkaNode.Create(Farmer.new(), players[i])
		jednostkaNode.add_to_group("Units")
		var unitPosition : Vector2 = Vector2(0,0)
		unitPosition.x =  castlePosition.x + (tileSize * 2)
		unitPosition.y =  castlePosition.y
		jednostkaNode.position = unitPosition
		add_child(jednostkaNode)
		players[i].units.append(jednostkaNode)

func _process(delta: float) -> void:
	pass
func _input(event: InputEvent) -> void:
	mousePosition = get_local_mouse_position()


func _on_knight_create_castle() -> void:
	var newCastlePosition : Vector2 = Vector2(0,0)
	newCastlePosition.x =  map.localTile.x * tileSize + tileSize/2
	newCastlePosition.y =  map.localTile.y * tileSize + tileSize/2
	for castle in currentPlayer.castleFields:
		var castle_position: Vector2 = castle.position
		var distance: float = floor(castle_position.distance_to(newCastlePosition))
		if (distance == 202 or distance == 230 or distance == 271) or distance <= 192 :
			print("Zamek nie może stać zbyt blisko innego 7x7")
			return
	if map.get_cell_alternative_tile(2,map.localTile) != 0 and map.get_cell_alternative_tile(4,map.localTile) != 0:
		var castle_scene = load(castle_scene_path)
		var castle_node = castle_scene.instantiate()
		castle_node.position = newCastlePosition
		castle_node.castleName = randomCastleName()
		castle_node.player = currentPlayer
		add_child(castle_node)
		castle_node.connect("CreateJednostka_v3",_CreateJednostkaFromCastle)
		camera.input_vector = newCastlePosition
		#console.text += "Stworzono zamek \n"
		currentPlayer.castleFields.push_back(castle_node)
		map.set_cell(4,map.localTile,2,Vector2i(0,7))
		currentPlayer.castles.append(castle_node)
	else:
		console.text += "Nie można utworzyć tutaj zamku"
	return

func _CreateJednostkaFromCastle(jednostka, positionToSetUnit):
	var jednostkaPath = preload("res://TypeArmy/SingleCharacter.tscn")
	var jednostkaNode = jednostkaPath.instantiate()
	jednostkaNode.connect("GetLocalTileMap",map._on_knight_get_local_tile_map)
	jednostkaNode.connect("DeleteLine",path._on_knight_delete_line)
	jednostkaNode.connect("SelectNodeToCreatePath",_on_knight_select_node_to_create_path)
	jednostkaNode.connect("CreateFarm",_on_knight_2_create_farm)
	jednostkaNode.connect("CreateCastle",_on_knight_create_castle)
	jednostkaNode.Create(jednostka, currentPlayer)
	jednostkaNode.add_to_group("Units")
	var unitPosition : Vector2 = Vector2(0,0)
	unitPosition.x =  positionToSetUnit.x + tileSize
	unitPosition.y =  positionToSetUnit.y + tileSize
	jednostkaNode.position = unitPosition
	add_child(jednostkaNode)
	currentPlayer.units.append(jednostkaNode)
	pass
	
	

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

var i = 1
#To dotyczy kiedy nastapi nowa tura
func _RefreshVariableOnTurn() -> void:
	RefreshFarmTileOnCurrentPlayer()
	RefreshCastleFarms()
	setCurrentPlayerNextPlayer(players[i%players.size()])
	RefreshTheHUD()
	RefreshUnitMovePoints()
	if (i%players.size()) == 0:
		turn += 1
		turnButton.text = str(turn)
	i += 1
	
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

@onready var foodValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/foodValue
@onready var goldValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/goldValue
@onready var playerNameValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer3/Label
@onready var flagValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer3/TextureRect
func RefreshTheHUD():
	foodValue.text = str(currentPlayer.food)
	goldValue.text = str(currentPlayer.gold)
	playerNameValue.text = currentPlayer.playerName
	flagValue.texture = load(currentPlayer.playerFlag)

func RefreshUnitMovePoints():
	var nodes_in_group = get_tree().get_nodes_in_group("Units")
	for node in nodes_in_group:
		node.movement = node.movePoints
	
func setCurrentPlayerNextPlayer(player : PlayerClass):
	currentPlayer = player
	currentPlayer.food = player.food
	currentPlayer.gold = player.gold
	currentPlayer.playerName = player.playerName
	currentPlayer.foodFields = player.foodFields
	currentPlayer.castleFields = player.castleFields
	currentPlayer.units = player.units
	currentPlayer.castles = player.castles
	currentPlayer.additionalAttack = player.additionalAttack
	currentPlayer.additionalDefense = player.additionalDefense
	currentPlayer.faith = player.faith
	currentPlayer.additionalFood = player.additionalFood
	currentPlayer.additionalGold = player.additionalGold
	

