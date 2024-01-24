extends Node2D # Inherits from the Global Node2D class

class_name TypeBuilding
var number #Sluzy do tego aby latwo rozpoznac jednostke
var nameBuilding
var requiredGold 
var requiredFood
var incomeGold
var incomeFood
var faith
var additionalAttack
var additionalDefense
var additionalFaith
var _texture
var opis
var timeToBuild

func _init():
	nameBuilding = ""
	requiredGold = 0
	requiredFood = 0
	_texture = ""
	opis = ""
	timeToBuild = 0

func setGoldIncome(gold):
	incomeGold = gold

func setFoodIncome(food):
	incomeFood = food
	
func setAdditionalAttack(attack):
	additionalAttack = attack

func setAdditionalDefense(defense):
	additionalDefense = defense
	
func setFaith(faithValue):
	faith = faithValue
	
func setAdditionalFaith(faithValue):
	additionalFaith = faithValue
