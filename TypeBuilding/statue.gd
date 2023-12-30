extends TypeBuilding

class_name Statue

func _init():
	nameBuilding = "Statue I"
	requiredGold = 15
	requiredFood = 0
	_texture = "res://TypeBuilding/statue.png"
	opis = "Daje +5 do wiary"
	
	self.setFaith(5)

	
