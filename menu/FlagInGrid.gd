extends TextureRect

signal ChangeFlagInGrid(textureFlag)
func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		emit_signal("ChangeFlagInGrid",self.texture)
	pass # Replace with function body.
