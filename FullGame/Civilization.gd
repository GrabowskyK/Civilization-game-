extends Node2D

@onready var camera = $Camera2D
@onready var map = $TileMap
@onready var labelSelectCastle = $LabelSelectCastle
@onready var path = $Path
@onready var currentPlayer = $PlayerVariables
@onready var turnButton = $Console/UI/MarginContainer/VBoxContainer/Day
@onready var FogNode = $Fog
@onready var consoleUI = $Console
@onready var infoGameTextBox = $InfoGame/PanelContainer/VBoxContainer/Info

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

var fogImageArray = []
var fogImage1
var fogImage2
var fogImage3
var fogImage4
var cities : Array = []
func _ready() -> void:
		# get Image from CompressedTexture2D and resize it
	lightImage = LightTexture.get_image()
	#lightImage.resize(300, 300)
	var result = lightImage
  # get center
	light_offset = Vector2(lightImage.get_size().x/2, lightImage.get_size().y/2)

  # create black canvas (fog)
	var mapSize = map.get_used_rect()
	
	fogImage1 = Image.create(mapSize.size.x * tileSize, mapSize.size.y * tileSize, false, Image.FORMAT_RGBA8)
	fogImage1.fill(Color.BLACK)
	fogImage2 = Image.create(mapSize.size.x * tileSize, mapSize.size.y * tileSize, false, Image.FORMAT_RGBA8)
	fogImage2.fill(Color.BLACK)
	fogImage3 = Image.create(mapSize.size.x * tileSize, mapSize.size.y * tileSize, false, Image.FORMAT_RGBA8)
	fogImage3.fill(Color.BLACK)
	fogImage4 = Image.create(mapSize.size.x * tileSize, mapSize.size.y * tileSize, false, Image.FORMAT_RGBA8)
	fogImage4.fill(Color.BLACK)
	fogImageArray.append(fogImage1)
	fogImageArray.append(fogImage2)
	fogImageArray.append(fogImage3)
	fogImageArray.append(fogImage4)
	fog.offset = Vector2(mapSize.position.x * tileSize, mapSize.position.y * tileSize)
	
	fogTexture = ImageTexture.create_from_image(fogImage1)
	fog.texture = fogTexture
	
  # get Rect2 from our Image to use it with .blend_rect() later
	light_rect = Rect2(Vector2.ZERO, lightImage.get_size())
	for i in range(0,GlobalVariables.flags.size(),1):
			var newPlayer = PlayerClass.new()
			newPlayer.playerFlag = GlobalVariables.flags[i]
			newPlayer.playerName = GlobalVariables.names[i]
			newPlayer.fogTexture = fogImageArray[i]
			players.append(newPlayer)

	StartGame()
	setCurrentPlayerNextPlayer(players[0])
	SetCamerOnFirstPlayersCastle()
	windowSize = self.get_viewport_rect()
	RefreshTheHUD()
	pass # Replace with function body.

func update_fog(pos, image):
	image.blend_rect(lightImage, light_rect, pos - light_offset - fog.offset)
	fog.texture.update(image)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("saveButton"):
		SaveData(saveDirPath + saveFileName)
	if event.is_action_pressed("loadButton"):
		LoadData(saveDirPath + saveFileName)
	pass
	
func _process(delta: float) -> void:
	pass
	
func StartGame():
	cities.append(polishCities.duplicate())
	cities.append(germanCities.duplicate())
	cities.append(norwegianCities.duplicate())
	cities.append(egyptianCities.duplicate())
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
			castle_node.castleName = randomCastleName(players[i])
			castle_node.player = players[i]
			add_child(castle_node)
			castle_node.connect("CreateJednostka_v3",_CreateJednostkaFromCastle)
			camera.input_vector = castlePosition
			#players[i].castleFields.push_back(castle_node)
			#players[i].castles.push_back(castle_node)
			#map.set_cell(4,castlePosition,2,Vector2i(0,7))
			players[i].castles.append(castle_node)
			update_fog(castle_node.position, players[i].fogTexture)
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
		update_fog(jednostkaNode.position, players[i].fogTexture)
	

func _on_knight_create_castle() -> void:
	# Sprwadzanie czy gracz posiada wystarczająco surowców
	if currentPlayer.gold >= 20 and currentPlayer.food >= 20:
		currentPlayer.gold -= 20 
		currentPlayer.food -= 20
		RefreshTheHUD()
		var newCastlePosition : Vector2 = Vector2(0,0)
		newCastlePosition.x =  map.localTile.x * tileSize + tileSize/2 # Odniesienie się do sceny (mapy)
		newCastlePosition.y =  map.localTile.y * tileSize + tileSize/2
		for castle in currentPlayer.castles:
			var localPositionCastle = Vector2(map.local_to_map(castle.position))
			#Poniższa liniijka sprawdza jak daleko jest punkt od punktu. Układ współrzędnych
			var distance: float = localPositionCastle.distance_to(Vector2(map.local_to_map(newCastlePosition)))
			if distance <= 5:
				currentPlayer.infoText += "Zamek nie może stać zbyt blisko innego 5x5" + "\n" 
				RefreshInfoConsole()
				return
		# Sprwadza czy już na danym "kafelku" występuje zamek lub farma
		if map.get_cell_alternative_tile(2,map.localTile) != 0 and map.get_cell_alternative_tile(4,map.localTile) != 0:
			var castle_scene = load(castle_scene_path) # Ładowanie sceny do stworzenia instancji
			var castle_node = castle_scene.instantiate() # Tworzenie instnacji ze sceny
			castle_node.position = newCastlePosition 
			castle_node.castleName = randomCastleName(currentPlayer)
			castle_node.player = currentPlayer
			add_child(castle_node) # Dodanie instnacji do drzewa projektu
			castle_node.connect("CreateJednostka_v3",_CreateJednostkaFromCastle) # Podłaczenie syngału 
			camera.input_vector = newCastlePosition
			map.set_cell(4,map.localTile,2,Vector2i(0,7))
			currentPlayer.castles.append(castle_node)
			update_fog(castle_node.position, currentPlayer.fogTexture)
			currentPlayer.infoText += "Gracz " + currentPlayer.playerName + " zbudował zamek." + "\n"
			RefreshInfoConsole()
		else:
			currentPlayer.infoText += "Nie można utworzyć tutaj zamku" + "\n"
			RefreshInfoConsole()
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
	update_fog(jednostkaNode.position, currentPlayer.fogTexture)
	pass
	


func randomCastleName(player) -> String: #Tutaj może wyrzucać bład
	var playerIndex = players.find(player,0)
	var exampleCities
	exampleCities = cities[playerIndex]
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
		currentPlayer.food -= 3
		currentPlayer.gold -= 2
		RefreshTheHUD()
	elif currentPlayer.food < 3 or currentPlayer.gold < 2:
		currentPlayer.infoText += "Nie masz wystarczająco surowców" + "\n"
		RefreshInfoConsole()
	else:
		currentPlayer.infoText += "Nie można utworzyć tutaj farmy" + "\n"
		RefreshInfoConsole()
	RefreshTheHUD()
	pass 

var i = 1

#To dotyczy kiedy nastapi nowa tura
func _RefreshVariableOnTurn() -> void:
	RefreshFarmTileOnCurrentPlayer() # Generuje dodatkowo surowce
	RefreshCastleFarms() # Odświeża pola farmy
	SetUnitsToNotSelected() # Powoduje, że żadna jednostka nie jest wybrana
	setCurrentPlayerNextPlayer(players[i%players.size()]) # Zmiana tury na kolejnego gracza
	RefreshInfoConsole() # Zmienia wyświetlaną konsole
	SetCamerOnFirstPlayersCastle() # Ustawia kamere na [0] zamek gracza
	PlayerIncomOnTurn() # Generuje przchod surowców
	RegenerateUnitsHp() # Regeneruje zdrowie jednostek
	RegenerateCastlesHp() # Regeneruje zdrowie zamków
	fog.texture = ImageTexture.create_from_image(currentPlayer.fogTexture) # zmienia "obraz" mgły wojny dla danego gracza
	SubItemsInProgress(currentPlayer) # Zmiensza czas budowania i rekrutowania jednostek
	CheckIfPossibleToUpgradeCivilization(currentPlayer) # Sprwadza czy jest możliwość zwiększenia poziomu ciwilizacji
	RefreshTheHUD() # Odświeża wartości surowców itd. dla gracza
	RefreshUnitMovePoints() # Odświeża punkty ruchów jednostek
	if (i%players.size()) == 0:
		turn += 1
		turnButton.text = "Dzień: " + str(turn)
	i += 1
	
	pass
	
func SetCamerOnFirstPlayersCastle():
	camera.input_vector = currentPlayer.castles[0].position
	
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
	#for farm in currentPlayer.castleFields:
	for farm in currentPlayer.castles:
		foodTemp += farm.RefreshTheFoodIncome()
	currentPlayer.food += foodTemp

func SetUnitsToNotSelected():
	for unit in currentPlayer.units:
		unit.isSelected = false
		unit.makeMove = false
		unit.current_point_path = []

func PlayerIncomOnTurn():
	currentPlayer.food += currentPlayer.additionalFood
	currentPlayer.gold += currentPlayer.additionalGold 
	currentPlayer.faith += currentPlayer.additionalFaith

@onready var foodValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/foodValue
@onready var goldValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/goldValue
@onready var playerNameValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer3/Label
@onready var flagValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer3/TextureRect
@onready var faithValue = $Console/UI/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer3/faithValue
func RefreshTheHUD():
	foodValue.text = str(currentPlayer.food)
	goldValue.text = str(currentPlayer.gold)
	playerNameValue.text = currentPlayer.playerName
	flagValue.texture = load(currentPlayer.playerFlag)
	faithValue.text = str(currentPlayer.faith)

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
	#currentPlayer.castleFields = player.castleFields
	currentPlayer.units = player.units
	currentPlayer.castles = player.castles
	currentPlayer.additionalAttack = player.additionalAttack
	currentPlayer.additionalDefense = player.additionalDefense
	currentPlayer.faith = player.faith
	currentPlayer.additionalFood = player.additionalFood
	currentPlayer.additionalGold = player.additionalGold
	currentPlayer.fogTexture = player.fogTexture
	fog.texture.update(currentPlayer.fogTexture)

func SubItemsInProgress(player: PlayerClass):
	for build in player.castles:
		if build.control.inProgressBuild.size() > 0:
			build.control.inProgressBuild[0].timeToBuild -= 1
		if build.control.inProgressArmy.size() > 0:
			build.control.inProgressArmy[0].timeToRecruit -= 1
		build.RefreshTheBuildStatus()
		build.RefreshTheUnitStatusInProgress()
		pass # Replace with function body.
			
func CheckIfPossibleToUpgradeCivilization(player : PlayerClass):
	var k = 0
	var numberOfBuildings = player.castles[0].control.tempBuild.budynki.size()
	for castle in player.castles:
		if castle.builtBuildings.size() == numberOfBuildings:
			k += 1
	if k >= 3:
		#warunek sprawdza gdyby miały dojść nowe cywilizacje, a numer się nie przekroczył ilości8
		if currentPlayer.numberCivilization < player.castles[0].control.tempBuild.builds.size():
			currentPlayer.numberCivilization += 1
		for castle in player.castles:
			castle.builtBuildings = []
			castle.control.tempBuild.RefreshBuildingView()
			castle.control.tempArmy.RefreshUnitView()
			castle.health = 125
			castle.attack = 50
			castle.defense = 50
			castle.side_length += 1
			castle.income = 8
			castle.level += 1
			castle.additionalAttack = 5
			castle.additionalDefense = 5
			castle.additionalFoodIncome = 3
			castle.additionalGoldIncome = 3

func IsGameEnd():
	for player in players:
		if player.faith >= 100:
			var gameEndPath = load("res://GameEnd/game_end.tscn")
			var gameEndNode = gameEndPath.instantiate()
			add_child(gameEndNode)
			gameEndNode.winner.text = currentPlayer.playerName
			gameEndNode.flag.texture = load(currentPlayer.playerFlag)
	if players.size() == 1:
		var gameEndPath = load("res://GameEnd/game_end.tscn")
		var gameEndNode = gameEndPath.instantiate()
		add_child(gameEndNode)
		gameEndNode.winner.text = "Gracz" + str(currentPlayer.playerName) + " wygrał!"
		gameEndNode.flag.texture = load(currentPlayer.playerFlag)

@onready var globalInfo = $GlobalInformation
func _IsPlayerDefeted():
	for player in players:
		if player.castles.is_empty():
			players.pop_at(players.find(player,0))
			for unit in player.units:
				unit.queue_free()
			globalInfo.info.text = "Gracz " + str(player.playerName) + " został pokonany"
			globalInfo.visible = true
			player.queue_free()
	pass


@export var fog: Sprite2D
@export var LightTexture: CompressedTexture2D
@export var debounce_time = 0.01

func RegenerateUnitsHp():
	for unit in currentPlayer.units:
		if unit.health < unit.maxHealth:
			unit.health += ceil(unit.maxHealth * 0.1)
			if unit.health > unit.maxHealth:
				unit.health = unit.maxHealth
		unit.healthBar.value = unit.health
		unit.healthValue.text = str(unit.health) + "/" + str(unit.healthBar.max_value)

func RegenerateCastlesHp():
	for castle in currentPlayer.castles:
		if castle.health < castle.maxHealth:
			castle.health += ceil(castle.maxHealth * 0.1)
			if castle.health > castle.maxHealth:
				castle.health = castle.maxHealth
		
var fogImage: Image
var lightImage: Image
var light_offset: Vector2
var fogTexture: ImageTexture
var light_rect: Rect2

const saveDirPath = "res://saves/"
const saveFileName = "save.json"
#To nie jest bezpieczne
const securityKey = "A1835JA8JDVASJ8D8"

func SaveData(path : String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, securityKey)
	if file == null:
		#Tutaj, że nie udało się zapisać
		return
	
	var data = {
		"players":[]
	}
	
	for player in players:
		var playerData = {
			"playerName": player.playerName,
			"playerFlag": player.playerFlag,
			"food": player.food,
			"gold": player.gold,
			"faith": player.faith,
			"additionalAttack": player.additionalAttack,
			"additionalDefense": player.additionalDefense,
			"additionalFood": player.additionalFood,
			"additionalGold": player.additionalGold,
			"additionalFaith": player.additionalFaith,
			"numberCivilization": player.numberCivilization,
			"fogTexture": player.fogTexture,
			"castles": []
		}
		for castle in player.castles:
			var castleData ={
				
			}
		data.players.append(playerData)
	
	
	var jsonString = JSON.stringify(data, "\t")
	file.store_string(jsonString)
	file.close()

func LoadData(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path,FileAccess.READ,securityKey)
		if file == null:
			return
		
		var content = file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(content)
		if data == null:
			print("Błąd")
	else:
		#
		return

func RefreshInfoConsole():
	infoGameTextBox.text = currentPlayer.infoText

var polishCities : Array = [
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

var germanCities : Array = [
	"Berlin",
	"Hamburg",
	"Monachium",
	"Kolonia",
	"Frankfurt nad Menem",
	"Stuttgart",
	"Düsseldorf",
	"Dortmund",
	"Essen",
	"Lipsk",
	"Drezno",
	"Hanower",
	"Norymberga",
	"Duisburg",
	"Bochum",
	"Wuppertal",
	"Bremeń",
	"Bonn",
	"Mannheim",
	"Karlsruhe"
]

var norwegianCities : Array = [
	"Oslo",
	"Bergen",
	"Stavanger",
	"Trondheim",
	"Drammen",
	"Fredrikstad",
	"Kristiansand",
	"Tromsø",
	"Sarpsborg",
	"Skien",
	"Ålesund",
	"Sandefjord",
	"Moss",
	"Porsgrunn",
	"Bodø",
	"Haugesund",
	"Arendal",
	"Tønsberg",
	"Molde",
	"Kongsberg"
]

var egyptianCities : Array = [
	"Kair",
	"Giza",
	"Aleksandria",
	"Szarm el-Szejk",
	"Luksor",
	"Asuan",
	"Hurghada",
	"6 października",
	"Tanta",
	"Ismailia",
	"Fajum",
	"Zagazig",
	"Asyut",
	"Dumyat",
	"Kom Ombo",
	"Port Said",
	"Mansura",
	"Al-Mahalla al-Kubra",
	"El-Minia",
	"Suez"
]
