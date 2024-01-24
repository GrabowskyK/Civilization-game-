extends TypeBuilding

class_name Barrack

func _init():
	nameBuilding = "Barrack"
	requiredGold = 10
	requiredFood = 10
	_texture = "res://TypeBuilding/barrack.png"
	opis = "Zapewnia +2 do ataku i obrony dla wszysktich jednostek"
	timeToBuild = 2
	self.setAdditionalAttack(2)
	self.setAdditionalDefense(2)

