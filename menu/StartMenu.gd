extends CanvasLayer

@onready var menu = $Menu
@onready var playerMenu = $PlayerMenu
func _on_start_game_pressed() -> void:
	menu.visible = false
	playerMenu.visible = true	
	pass # Replace with function body.
