extends PanelContainer

@onready var nazwa = $HBoxContainer/VBoxContainer/nazwa
@onready var opis = $HBoxContainer/VBoxContainer/Opis
@onready var image = $HBoxContainer/TextureRect
@onready var foodValue = $HBoxContainer/VBoxContainer/ColorRect/HBoxContainer2/foodValue
@onready var goldValue = $HBoxContainer/VBoxContainer/ColorRect/HBoxContainer/goldValue
@onready var timeValue = $HBoxContainer/VBoxContainer/ColorRect/HBoxContainer3/timeValue
var number 

signal CreateBuilding(buildingObject)
func _on_build_button_pressed() -> void:
	emit_signal("CreateBuilding",self)
	pass # Replace with function body.
