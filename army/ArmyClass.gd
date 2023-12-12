class_name ArmyClass

extends Object

var attack : int
var defense : int
var movePoints : int
var texture 
# Konstruktor ustawiający domyślne wartości ataku i obrony
func _init(attackValue: int = 1, defenseValue: int = 1, movePoints : int = 1):
	attack = attackValue
	defense = defenseValue
