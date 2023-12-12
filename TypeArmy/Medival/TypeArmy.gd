extends Node2D # Inherits from the Global Node2D class

class_name TypeArmy
var nameArmy
var health: int 
var attack: int
var defense: int
var movePoints: int
var cost: int
var _texture 
var opis 

func _init():
	nameArmy = ""
	attack = 1
	defense = 1
	movePoints = 1
	cost = 1
	_texture = ""
	opis = ""
	#player = 1

#func getAttack():
#	return self.attack
#
#func info():
#	return self.texture

