extends PopupMenu
@onready var mainNode = $".."

enum PopupIds {
	create_castle,
	create_knight,
	exit
}

signal createCastleFrompopup
signal createKnightFrompopup
signal getLocalTileMap

func _ready() -> void:
	self.add_item("Create castle", PopupIds.create_castle)
	self.add_item("Create knight", PopupIds.create_knight)
	self.add_item("Exit", PopupIds.exit)

		
func _on_id_pressed(id: int) -> void:
	
	match id:
		PopupIds.create_castle:
			emit_signal("createCastleFrompopup")
		PopupIds.create_knight:
			emit_signal("createKnightFrompopup")
		PopupIds.exit:
			self.hide()
			print("Exit")
	pass # Replace with function body.


func _on_index_pressed(index: int) -> void:
	print(index)
	pass # Replace with function body.



#Funkcja służy do pobierania pozycji kafla z TileMap po otworzeniu Popup
func _on_about_to_popup() -> void: 
	mainNode.camera.moveable = false
	emit_signal("getLocalTileMap")
	pass # Replace with function body.


func _on_popup_hide() -> void:
	mainNode.camera.moveable = true
	pass # Replace with function body.
