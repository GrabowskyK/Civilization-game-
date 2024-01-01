extends VBoxContainer
@onready var mainControl = $"../../../../../../../../../../.."
var newInstance

func _on_grid_container_sent_unit_to_progress(unitObject) -> void:
	mainControl.inProgressArmy.append(unitObject)
	var unit = preload("res://Castle/Control/ArmyInProgress.tscn")
	newInstance = unit.instantiate()
	add_child(newInstance)
	newInstance.image.texture = load(unitObject._texture)
	newInstance.nazwa.text = unitObject.nameArmy
	newInstance.days.text = str(unitObject.timeToRecruit) + " days" 
	pass # Replace with function body.


func _on_draw() -> void:
	var child = get_children()
	var k = 0

	while child.size() > mainControl.inProgressArmy.size():
		#Czyli tutaj jak dajesz queue free to to nic nie zmienia. Musisz usuwać instancje chyba nie wiem. Albo piuerdol pobieranie znowu tego get_child()
		child[k].queue_free()
		child.pop_at(0)
		#k += 1

	for i in range(0,child.size(),1):
		child[i].days.text = str(mainControl.inProgressArmy[i].timeToRecruit)

	pass # Replace with function body.
