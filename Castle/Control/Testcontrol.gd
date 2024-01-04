extends Control

@onready var nameCastle = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/NameCastle
@onready var foodValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/FoodValue
@onready var incomeValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/IncomeValue
@onready var totalArmy = $PanelContainer/Box/VBoxContainer/HBoxContainer/ScrollContainer/MarginContainer2/GridContainer
@onready var armyView = $PanelContainer/Box/VBoxContainer/HBoxContainer/Army
@onready var buildingsView = $PanelContainer/Box/VBoxContainer/HBoxContainer/Buildings
@onready var inProgressView = $PanelContainer/Box/VBoxContainer/HBoxContainer/InProgress
@onready var totalFood = $PanelContainer/Box/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/Label2
@onready var totalGold = $PanelContainer/Box/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer2/Label2

@onready var tempBuild = $PanelContainer/Box/VBoxContainer/HBoxContainer/Buildings/MarginContainer2/Buildings
@onready var tempArmy = $PanelContainer/Box/VBoxContainer/HBoxContainer/Army/MarginContainer2/GridContainer
var inProgressBuild : Array = []
var inProgressArmy : Array = []

func _on_close_pressed() -> void:
	var parent = get_parent()
	self.visible = false
	parent.isCastleSelected = false
	parent.mainNode.lockZooming = true
	parent.mainNode.camera.zoom = Vector2(1.5,1.5)
	pass # Replace with function body.

signal CreateJednostke_v2(jednostka)
func _on_grid_container_create_knight_from_castle(jednostkaType) -> void:
	emit_signal("CreateJednostke_v2",jednostkaType)
	pass # Replace with function body.

func _on_army_button_pressed() -> void:
	if armyView.visible == false:
		armyView.visible = true
		buildingsView.visible = false
		inProgressView.visible = false
	pass # Replace with function body.

func _on_building_button_pressed() -> void:
	if buildingsView.visible == false:
		buildingsView.visible = true
		armyView.visible = false
		inProgressView.visible = false
	pass # Replace with function body.


func _on_in_progress_button_pressed() -> void:
	if inProgressView.visible == false:
		buildingsView.visible = false
		armyView.visible = false
		inProgressView.visible = true
	
	pass # Replace with function body.
