extends TypeBuilding

class_name STTemple

func _init():
	nameBuilding = "Temple"
	requiredGold = 20
	requiredFood = 15
	_texture = "res://TypeBuilding/BuildingLvl2/temple.png"
	opis = "Co runde daje +2 do wiary oraz +5 do ataku"
	timeToBuild = 7
	self.setAdditionalFaith(2)
	self.setAdditionalAttack(5)

