extends CanvasLayer
@onready var listPlayers = $PanelContainer/VBoxContainer2/MarginContainer/ScrollContainer/ListPlayer
# Przełączanie pomiędzy scenami
# Wczytaj nową scenę (np. "res://sceny/Gra.tscn") i przełącz się na nią
func load_and_switch_to_game_scene() -> void:
	get_tree().change_scene_to_file("res://FullGame/Civilization.tscn")
	

func _on_start_game_pressed() -> void:
	for player in listPlayers.playersNode:
		if player != null:
			GlobalVariables.names.append(player.namePlayer.text) 
			GlobalVariables.flags.append(player.flag.texture.get_path()) 
	load_and_switch_to_game_scene()
