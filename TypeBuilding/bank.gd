extends TypeBuilding

class_name Bank

func _init():
	nameBuilding = "Bank"
	requiredGold = 12
	requiredFood = 5
	_texture = "res://TypeBuilding/BANK.png"
	opis = "Generuje +3 gold co ture"
	timeToBuild = 2
	self.setGoldIncome(3)

