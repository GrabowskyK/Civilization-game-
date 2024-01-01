extends PanelContainer

@onready var nazwa = $HBoxContainer/VBoxContainer/UnitName
@onready var days = $HBoxContainer/VBoxContainer/HBoxContainer/days
@onready var image = $HBoxContainer/TextureRect

func _on_button_pressed() -> void:
	var parent = get_parent().mainControl.inProgressArmy.pop_at(self.get_index())
	self.queue_free()
	pass # Replace with function body.
