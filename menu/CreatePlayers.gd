extends MarginContainer

@onready var boxPlayers = $ScrollContainer/VBoxContainer2
@onready var buttonAddPlayers = $ScrollContainer/VBoxContainer2/Button

func _process(delta: float) -> void:
	if boxPlayers.get_child_count() == 5:
		buttonAddPlayers.visible = false
	else:
		buttonAddPlayers.visible = true
		
func _on_button_pressed() -> void:
	var nodePath = load("res://menu/player_crete_game.tscn")
	var nodePlayer = nodePath.instantiate()
	boxPlayers.add_child(nodePlayer)
	boxPlayers.move_child(nodePlayer,1)
	
	pass # Replace with function body.
