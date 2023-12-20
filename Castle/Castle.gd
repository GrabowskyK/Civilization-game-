extends Area2D

class_name CastleClass
var player: String
var castleName: String = ""
var defend = 1
var attack = 1
var level = 1
var builtBuildings: Array = [] #Zbudowane budynki
var currentInCastle: Array = [] #Jakie jednostki są w zamku
var food = 1
var income = 0

#Tutja można dalej rozwijać
@onready var mainNode = $".."
@onready var sprite2D = $Sprite2D
@onready var control = $Control
@onready var map = $"../TileMap"

var isCastleSelected : bool = false
var mousePosition
var mouseEntered : bool = false
var tile_size = Vector2(64,64)
var side_length = 2
signal SetCameraInCastle(value1 : Vector2)

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	print(map.get_surrounding_cells(position))
	control.nameCastle.text = castleName
	control.foodValue.text = str(food)
	control.incomeValue.text = str(income)
	RefreshTheFoodIncome()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

func _input(event: InputEvent) -> void:
	mousePosition = get_global_mouse_position()
	if(event.is_action_pressed("click") and mouseEntered == true):
		mainNode.camera.input_vector = mousePosition
		isCastleSelected = true
		control.visible = true
	if(event.is_action_pressed("up")):
		RefreshTheFoodIncome()
	pass

func _on_castle_menu_set_income() -> void:
	income = income + 1
	print("Robi się")
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	mouseEntered = false
	pass # Replace with function body.

func RefreshTheFoodIncome(): #Ma się robić co runde
	income = 0
	var start_x = int((position.x-32 - side_length * tile_size.x) / tile_size.x)
	var start_y = int((position.y-32 - side_length * tile_size.y) / tile_size.y)
	var end_x = int((position.x-32 + side_length * tile_size.x) / tile_size.x)
	var end_y = int((position.y-32 + side_length * tile_size.y) / tile_size.y)

	# Sprawdź, czy w obszarze znajduje się jakiś kafelek
	for x in range(start_x, end_x + 1):
		for y in range(start_y, end_y + 1):
			var tile_index = map.get_cell_alternative_tile(3,Vector2(x,y))
			if tile_index != -1:
				income += 2
				#print("Znaleziono kafelek na pozycji:", Vector2(x, y), "o indeksie:", tile_index)
	return income
