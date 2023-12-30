extends TypeBuilding

class_name Barrack

func _init():
	nameBuilding = "Barrack I"
	requiredGold = 10
	requiredFood = 10
	_texture = "res://TypeBuilding/BANK.png"
	opis = "Zapewnia +1 do ataku i obrony dla wszysktich jednostek"
	self.setAdditionalAttack(1)
	self.setAdditionalDefense(1)

