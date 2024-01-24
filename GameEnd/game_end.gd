extends CanvasLayer

@onready var flag = $MarginContainer/VBoxContainer/TextureRect
@onready var winner = $MarginContainer/VBoxContainer/WhoWIn

func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/StartMenu.tscn")
	pass # Replace with function body.
