extends TypeBuilding

class_name Bank

func _init():
	nameBuilding = "Bank I"
	requiredGold = 12
	requiredFood = 5
	_texture = "res://TypeBuilding/BANK.png"
	opis = "Generuje +3 gold co 2 tury"
	timeToBuild = 2
	self.setGoldIncome(3)

