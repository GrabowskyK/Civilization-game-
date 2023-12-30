extends MarginContainer
@onready var flags = $"../../GridContainer"
@onready var currentSelectedPlayer = $ScrollContainer/ListPlayer/PlayerCreteGame
@onready var listPlayers = $ScrollContainer/ListPlayer
var path = "res://menu/flags/"
func _on_player_crete_game_change_flag(flag) -> void:
	flags.visible = true
	currentSelectedPlayer = flag
	pass # Replace with function body.


func _on_grid_container_change_player_flag(texture) -> void:
	currentSelectedPlayer.flag.texture = texture
	flags.visible = false
	pass # Replace with function body.
