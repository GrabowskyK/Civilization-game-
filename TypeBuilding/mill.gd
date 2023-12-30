extends TypeBuilding

class_name Mill

func _init():
	nameBuilding = "Mill I"
	requiredGold = 8
	requiredFood = 10
	_texture = "res://TypeBuilding/mill.png"
	opis = "Każdy zbiór generuje dodatkowo 1 sztuke zboża więcej"
	self.setFoodIncome(1)
	# Teraz możesz użyć getAttack()
