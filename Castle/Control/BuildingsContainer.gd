extends VBoxContainer
@onready var mainNode = $"../../../../../../.."
var newInstance 
var building : PackedScene = preload("res://Castle/Control/BuildingContainer.tscn") 
var budynkiLvl1 : Array = [Bank.new(),Mill.new(),Statue.new(), Barrack.new()]
var budynkiLvl2 : Array = [DeathStar.new(), STBank.new(), STTemple.new()]
#tablica ktora przechowuje budynki w zależności od obecnej cywilizacji
var builds : Array = [budynkiLvl1, budynkiLvl2]
var budynki : Array = []
var builded : Array = []
var notAvaibleToBuild : Array = []

var parent
func _ready() -> void:
	parent = mainNode.get_parent()
	budynki = builds[parent.player.numberCivilization]
	var i = 0
	for item in budynki:
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
#Funkcja która sprawdza czy jest wystarczająco surowca. 
func _updatePlayerStatsAfterBuild(buildingObject):
	var parent = mainNode.get_parent()
	var building = budynki[buildingObject.number]
	if parent.player.gold < building.requiredGold or parent.player.food < building.requiredFood:
		print("Posiadasz za mało surowców!")
	else:
		parent.player.gold -= building.requiredGold
		parent.player.food -= building.requiredFood
		mainNode.totalFood.text = str(parent.player.food)
		mainNode.totalGold.text = str(parent.player.gold)
		var childs = get_tree()
		mainNode.inProgressBuild.append(building)
		#sygnał który pozwala na wyświelanie w InProgressBuilding
		emit_signal("SendToProgress",building)
		childs.queue_delete(buildingObject)
		
func RefreshBuildingView():
	#Gdy bedzie 4 budynki itd to zakutaliozuj do budynkilvl2
	for child in get_children():
		child.queue_free()
	budynki = builds[parent.player.numberCivilization]
	var i = 0
	for item in budynki:
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
	

