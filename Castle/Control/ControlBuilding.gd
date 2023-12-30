extends PanelContainer

@onready var nazwa = $HBoxContainer/VBoxContainer/nazwa
@onready var opis = $HBoxContainer/VBoxContainer/Opis
@onready var image = $HBoxContainer/TextureRect
@onready var foodValue = $HBoxContainer/VBoxContainer/HBoxContainer2/foodValue
@onready var goldValue = $HBoxContainer/VBoxContainer/HBoxContainer/goldValue

var number 

signal CreateBuilding(buildingObject)
func _on_build_button_pressed() -> void:
	emit_signal("CreateBuilding",self)
	pass # Replace with function body.
