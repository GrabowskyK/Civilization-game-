extends VBoxContainer
@onready var mainNode = $"../../../../../../.."
var newInstance 
var building : PackedScene = preload("res://Castle/Control/BuildingContainer.tscn") 
var budynkiLvl1 : Array = [Bank.new(),Mill.new(),Statue.new(), Barrack.new()]
var builded : Array = []
var notAvaibleToBuild : Array = []


func _ready() -> void:
	var i = 0
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
		newInstance.timeValue.text = str(item.timeToBuild) + " days" 
		i += 1

signal SendToProgress(buildObject)
func _updatePlayerStatsAfterBuild(buildingObject):
	var parent = mainNode.get_parent()
	var building = budynkiLvl1[buildingObject.number]
	if parent.player.gold < building.requiredGold or parent.player.food < building.requiredFood:
		print("Posiadasz za mało surowców!")
	else:
		var childs = get_tree()
		mainNode.inProgressBuild.append(building)
		emit_signal("SendToProgress",building)
		childs.queue_delete(buildingObject)
		

