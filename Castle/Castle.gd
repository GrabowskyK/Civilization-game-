extends Area2D

class_name CastleClass
var player
var castleName: String = ""
var health = 5
var defense = 1
var attack = 1
var level = 1
var builtBuildings: Array = [] #Zbudowane budynki
var currentInCastle: Array = [] #Jakie jednostki są w zamku
var income = 0
var isEntered = false
#Tutja można dalej rozwijać
@onready var mainNode = $".."
@onready var sprite2D = $Sprite2D
@onready var control = $Control
@onready var map = $"../TileMap"
@onready var flag = $Sprite2D/TextureRect

var isCastleSelected : bool = false
var mousePosition
var mouseEntered : bool = false
var tile_size = Vector2(64,64)
var side_length = 0
signal SetCameraInCastle(value1 : Vector2)

func _ready() -> void:
	RefreshTheFoodIncome()
	flag.texture = load(player.playerFlag)
	pass # Replace with function body.

func _process(delta: float) -> void:

	pass

func _input(event: InputEvent) -> void:
	mousePosition = get_global_mouse_position()
	if player == mainNode.currentPlayer:
		if(event.is_action_pressed("click") and mouseEntered == true): #Gdy otworze menu zamku
			mainNode.camera.input_vector = mousePosition
			isCastleSelected = true
			control.visible = true
			mainNode.camera.zoom = Vector2(1.5,1.5)
			mainNode.lockZooming = false
			control.totalFood.text = str(player.food)
			control.totalGold.text = str(player.gold)
		pass

func _on_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouseEntered = false
	pass # Replace with function body.

func RefreshTheFoodIncome(): #Ma się robić co runde
	income = 0
	var start_x = int((position.x-32 - (level * tile_size.x)) / tile_size.x) #-14
	var start_y = int((position.y-32 - (level * tile_size.y)) / tile_size.y)
	var end_x = int((position.x-32 + (level * tile_size.x)) / tile_size.x) #-12
	var end_y = int((position.y-32 + (level * tile_size.y)) / tile_size.y) 

	# Sprawdź, czy w obszarze znajduje się jakiś kafelek
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_index = map.get_cell_alternative_tile(2,Vector2(1,2))
			print("Znaleziono kafelek na pozycji:", Vector2(x, y), "o indeksie:", tile_index)
			if tile_index != -1:
				income += 2
				print("Znaleziono kafelek na pozycji:", Vector2(x, y), "o indeksie:", tile_index)
	return income

signal CreateJednostka_v3(jednostka_v3, positionToSetUnit)
func _on_control_create_jednostke_v_2(jednostka) -> void:
	emit_signal("CreateJednostka_v3",jednostka, self.position)
	pass # Replace with function body.

#Funcja, która dla każdego budynku w każdym zamku sprawda czy już został wybudowany
#Jeżeli tak to dodaje statystyki
func RefreshTheBuildStatus():
	for build in control.inProgressBuild:
		if(build.timeToBuild == 0):
			builtBuildings.append(build)
			if build.additionalAttack != null:
				player.additionalAttack += build.additionalAttack
			if build.additionalDefense != null:
				player.additionalDefense += build.additionalDefense
			if build.faith != null:
				player.faith += build.faith
			if build.incomeFood != null:
				player.additionalFood += build.incomeFood
			if build.incomeGold != null:
				player.additionalGold += build.incomeGold
			control.inProgressBuild.pop_at(0)
			
func RefreshTheUnitStatusInProgress():
	for unit in control.inProgressArmy:
		if(unit.timeToRecruit == 0):
			emit_signal("CreateJednostka_v3",unit, self.position)
			control.inProgressArmy.pop_at(0)
			
	
