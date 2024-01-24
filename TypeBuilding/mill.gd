extends TypeBuilding

class_name Mill

func _init():
	nameBuilding = "Mill"
	requiredGold = 8
	requiredFood = 10
	_texture = "res://TypeBuilding/mill.png"
	opis = "Generuje dodatkowo 1 sztuke zboża przy farmie więcej oraz 1 sztuke co ture"
	timeToBuild = 3
	self.setFoodIncome(1)
	# Teraz możesz użyć getAttack()
