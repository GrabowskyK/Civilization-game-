extends Node2D

@onready var tileMap : TileMap = $MapaGD
const Enums = preload("res://map/EnumsPopup.gd") #Tutaj znajdują sie enumy do popupa
var mouse_positon

var tileValues = [2,4]
var goldAmount = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
