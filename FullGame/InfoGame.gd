extends CanvasLayer

@onready var info = $PanelContainer/VBoxContainer/Info
func _on_button_pressed() -> void:
	if info.visible == true:
		info.visible = false
	else:
		info.visible = true
	pass # Replace with function body.



#func _on_info_text_changed() -> void:
#	var cl = info.get_line_count()
#	info.cursor_set_line(cl)
#	pass # Replace with function body.
#
#
#func _on_info_text_set() -> void:
#	var cl = info.get_line_count()
#	info.scroll_vertical = info.position.x
#	pass # Replace with function body.
