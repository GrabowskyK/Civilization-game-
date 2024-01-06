extends CanvasLayer

@onready var info = $PanelContainer/ColorRect/MarginContainer/ColorRect/MarginContainer/VBoxContainer/Info

func _on_ok_button_pressed() -> void:
	self.visible = false
	get_parent().IsGameEnd()
	pass # Replace with function body.
