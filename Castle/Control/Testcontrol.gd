extends Control

@onready var nameCastle = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/NameCastle
@onready var foodValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/FoodValue
@onready var incomeValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/IncomeValue
@onready var totalArmy = $PanelContainer/Box/VBoxContainer/HBoxContainer/ScrollContainer/MarginContainer2/GridContainer


func _on_close_pressed() -> void:
	self.visible = false
	get_parent().isCastleSelected = false
	pass # Replace with function body.
