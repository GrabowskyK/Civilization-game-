extends VBoxContainer

@onready var healthValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer4/HealthValue
@onready var attackValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer/AttackValue
@onready var defendValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer2/DefndValue
@onready var costValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer3/CostValue
@onready var moveValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer5/MovePoints
@onready var opisValue = $ColorRect/MarginContainer/VBoxContainer/Opis
@onready var nameValue = $Name
@onready var textureValue = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer4/TextureRect
@onready var nameButton = $Button

var nameButtonJendostki = nameValue #Sluzy do tego, aby wiedziec ktora jedostka ma zostac stworzona
signal CreateJendostka(nameJednostki : String)

func _on_button_pressed() -> void:
	print(nameButtonJendostki)
	emit_signal("CreateJendostka", nameButtonJendostki) #Tworzenie jednostki
	pass # Replace with function body.


func _on_create_jendostka(nameJednostki) -> void:
	print(get_parent_control().get_parent_control())
	print(nameJednostki)
	pass # Replace with function body.
