extends GridContainer

var flagsPath = "res://menu/flags/"

var flags : Array = []
var textureNode
func _ready() -> void:
	var flagToGridPath = load("res://menu/texture_rect.tscn")
	dir_contents(flagsPath)
	for i in range(0, flags.size(), 2):
		textureNode = flagToGridPath.instantiate()
		add_child(textureNode)
		textureNode.texture = load("res://menu/flags/" + flags[i])
		textureNode.connect("ChangeFlagInGrid",_changeFlagInGrid)

func dir_contents(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print(file_name)
				flags.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
signal ChangePlayerFlag(texture)
func _changeFlagInGrid(textureFlag):
	emit_signal("ChangePlayerFlag",textureFlag)
	pass
