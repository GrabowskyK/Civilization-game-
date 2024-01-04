extends TypeBuilding

class_name STBank

func _init():
	nameBuilding = "Bank"
	requiredGold = 28
	requiredFood = 10
	_texture = "res://TypeBuilding/BuildingLvl2/STbank.png"
	opis = "+7 złota co runde"
	timeToBuild = 6
	self.setGoldIncome(7)

