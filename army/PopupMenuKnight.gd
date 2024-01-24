extends PopupMenu

@onready var unit = $".."

#Wieśniak
enum PopupIds {
	move,
	createCastle,
	createFarm,
	createRoad,
	exit
}

signal GetLocalTileMap

func _ready() -> void:
	if unit.jednostkaName == "Farmer" or unit.jednostkaName == "Artuditu":
		self.add_item("Move", PopupIds.move)
		#self.add_item("Create castle", PopupIds.createCastle)
		self.add_item("Create farm", PopupIds.createFarm)
		self.add_item("Create road", PopupIds.createRoad)
		self.add_item("Exit", PopupIds.exit)
	else:
		self.add_item("Move", PopupIds.move)
		self.add_item("Create castle", PopupIds.createCastle)
		#self.add_item("Create farm", PopupIds.createFarm)
		self.add_item("Create road", PopupIds.createRoad)
		self.add_item("Exit", PopupIds.exit)


