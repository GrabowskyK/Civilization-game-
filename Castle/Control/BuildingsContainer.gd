extends VBoxContainer
var newInstance 
var building : PackedScene = preload("res://Castle/Control/BuildingContainer.tscn") 
var budynkiLvl1 : Array = [Bank.new(),Mill.new(),Statue.new(), Barrack.new()]

var builded : Array = []
var notAvaibleToBuild : Array = []

var i = 0
func _ready() -> void:
	var result  = Bank.new()
	print(result.incomeGold)
	for item in budynkiLvl1:
		newInstance = building.instantiate()
		add_child(newInstance)
		newInstance.connect("CreateBuilding", _updatePlayerStatsAfterBuild)
		newInstance.number = i
		newInstance.foodValue.text = str(item.requiredFood)
		newInstance.goldValue.text = str(item.requiredGold)
		newInstance.image.texture = load(item._texture)
		newInstance.opis.text = item.opis
		newInstance.nazwa.text = item.nameBuilding
		i += 1

signal UpdatePlayerStats(buildObject)
func _updatePlayerStatsAfterBuild(buildingObject):
	var childs = get_tree()
	var building = buildingObject.number
	emit_signal("UpdatePlayerStats", budynkiLvl1[building])
	match building:
		0:
			builded.append(budynkiLvl1[building])
			childs.queue_delete(buildingObject)
		1:
			builded.append(budynkiLvl1[building])
			childs.queue_delete(buildingObject)
		2:
			builded.append(budynkiLvl1[building])
			childs.queue_delete(buildingObject)
		3:
			builded.append(budynkiLvl1[building])
			childs.queue_delete(buildingObject)
	
