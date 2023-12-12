extends Area2D

class_name CastleClass
var castleName: String = ""
var defend = 1
var attack = 1
var level = 1
var builtBuildings: Array = [] #Zbudowane budynki
var currentInCastle: Array = [] #Jakie jednostki są w zamku
var food = 1
var income = 1

#Tutja można dalej rozwijać
@onready var mainNode = $".."
@onready var sprite2D = $Sprite2D
@onready var control = $Control

var isCastleSelected : bool = false
var mousePosition
var mouseEntered : bool = false
signal SetCameraInCastle(value1 : Vector2)

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	control.nameCastle.text = castleName
	control.foodValue.text = str(food)
	control.incomeValue.text = str(income)
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
