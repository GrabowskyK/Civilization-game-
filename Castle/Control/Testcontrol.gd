extends Control

@onready var nameCastle = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/NameCastle
@onready var foodValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/FoodValue
@onready var incomeValue = $PanelContainer/Box/VBoxContainer/PanelContainer/HBoxContainer/Numbers/IncomeValue
@onready var totalArmy = $PanelContainer/Box/VBoxContainer/HBoxContainer/ScrollContainer/MarginContainer2/GridContainer
@onready var armyView = $PanelContainer/Box/VBoxContainer/HBoxContainer/Army
@onready var buildingsView = $PanelContainer/Box/VBoxContainer/HBoxContainer/Buildings

func _on_close_pressed() -> void:
	self.visible = false
	var parent = get_parent()
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
	pass # Replace with function body.

func _on_building_button_pressed() -> void:
	if buildingsView.visible == false:
		buildingsView.visible = true
		armyView.visible = false
	pass # Replace with function body.

func _on_buildings_update_player_stats(buildObject) -> void:
	var parent = get_parent()
	if buildObject.additionalAttack != null:
		parent.player.additionalAttack += buildObject.additionalAttack
	if buildObject.additionalDefense != null:
		parent.player.additionalDefense += buildObject.additionalDefense
	if buildObject.faith != null:
		parent.player.faith += buildObject.faith
	if buildObject.incomeFood != null:
		parent.player.additionalFood += buildObject.incomeFood
	if buildObject.incomeGold != null:
		parent.player.additionalGold += buildObject.incomeGold
	pass # Replace with function body.
