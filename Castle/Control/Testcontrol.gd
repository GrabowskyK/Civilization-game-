extends Control

@onready var nameCastle = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Numbers/NameCastle
@onready var foodValue = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Numbers/FoodValue
@onready var incomeValue = $PanelContainer/MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Numbers/IncomeValue
@onready var totalArmy = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/MarginContainer2/GridContainer

	

func _on_button_pressed() -> void:
#	var test_control_scene = preload("res://Castle/UICastle.tscn")  # Podaj właściwą ścieżkę
#	var test_control_instance = test_control_scene.instantiate()
#
#	# Zastąp aktualną warstwę CanvasLayer TestControl w drzewie węzłów
#	var parent_node = get_parent()
#	parent_node.add_child(test_control_instance)
#	parent_node.remove_child(self)
	pass # Replace with function body.


func _on_close_pressed() -> void:
	self.visible = false
	var parent = get_parent()
	parent.isCastleSelected = false
	print(parent.isCastleSelected)
	pass # Replace with function body.
