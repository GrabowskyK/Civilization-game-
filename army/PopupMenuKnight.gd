extends PopupMenu

#Wieśniak
enum PopupIds {
	move,
	createCastle,
	createFarm,
	createRoad,
	#createWood,
	#createMine,
	exit
}

signal GetLocalTileMap

func _ready() -> void:
	self.add_item("Move", PopupIds.move)
	self.add_item("Create castle", PopupIds.createCastle)
	self.add_item("Create farm", PopupIds.createFarm)
	self.add_item("Create road", PopupIds.createRoad)
	#self.add_item("Create wood", PopupIds.createWood)
	#self.add_item("Create mine", PopupIds.createMine)
	self.add_item("Exit", PopupIds.exit)





