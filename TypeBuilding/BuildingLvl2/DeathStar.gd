extends TypeBuilding

class_name DeathStar

func _init():
	nameBuilding = "Death Star"
	requiredGold = 20
	requiredFood = 20
	_texture = "res://TypeBuilding/BuildingLvl2/deathstar.png"
	opis = "+10 do ataku i obrony oraz +2 złota co runde"
	timeToBuild = 7
	self.setAdditionalAttack(10)
	self.setAdditionalDefense(10)
	self.setGoldIncome(2)
