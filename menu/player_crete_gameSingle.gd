extends HBoxContainer
var isSelected = false
@onready var flag = $flag
@onready var namePlayer = $NamePlayer

func _on_button_pressed() -> void:
	self.queue_free()
	pass # Replace with function body.

signal ChangeFlag
func _input(event: InputEvent) -> void:
	if isSelected == true and event.is_action_pressed("click"):
		emit_signal("ChangeFlag",self)


func _on_flag_mouse_entered() -> void:
	isSelected = true
	pass # Replace with function body.


func _on_flag_mouse_exited() -> void:
	isSelected = false
	pass # Replace with function body.
