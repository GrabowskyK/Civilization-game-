extends VBoxContainer
@onready var buttonAddPlayer = $AddPlayer
@onready var mainParent = $"../.."
var playersNode : Array = []
func _process(delta: float) -> void:
	if get_child_count() == 5:
		buttonAddPlayer.visible = false
	else:
		buttonAddPlayer.visible = true
		

func _on_add_player_pressed() -> void:
	var nodePath = load("res://menu/player_crete_game.tscn")
	var node = nodePath.instantiate()
	add_child(node)
	node.connect("ChangeFlag",mainParent._on_player_crete_game_change_flag)
	move_child(node,get_child_count()-2)
	playersNode.append(node)
	pass # Replace with function body.


