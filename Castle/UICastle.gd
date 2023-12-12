extends CanvasLayer


func _on_button_2_pressed() -> void:
	load_test_control()
	pass # Replace with function body.


func _on_button_pressed() -> void:
	pass # Replace with function body.

func load_test_control() -> void:
	var test_control_scene = preload("res://Testcontrol.tscn")  # Podaj właściwą ścieżkę
	var test_control_instance = test_control_scene.instantiate()
	
	# Zastąp aktualną warstwę CanvasLayer TestControl w drzewie węzłów
	var parent_node = get_parent()
	parent_node.add_child(test_control_instance)
	parent_node.remove_child(self)
