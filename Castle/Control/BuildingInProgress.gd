extends VBoxContainer
@onready var mainControl = $"../../../../../../../../../../.."
var newInstance
var tempBuild : Array = []
#tablica do pomocy

func _on_buildings_send_to_progress(buildObject) -> void:
	var building = preload("res://Castle/Control/BuildingInProgress.tscn")
	newInstance = building.instantiate()
	add_child(newInstance)
	newInstance.image.texture = load(buildObject._texture)
	newInstance.nazwa.text = buildObject.nameBuilding
	newInstance.timeValue.text = str(buildObject.timeToBuild) + " days" 
	tempBuild.append(newInstance)
	pass # Replace with function body.


func _on_draw() -> void:
	var child = get_children()
	var k = 0

	while child.size() > mainControl.inProgressBuild.size():
		#Czyli tutaj jak dajesz queue free to to nic nie zmienia. Musisz usuwać instancje chyba nie wiem. Albo piuerdol pobieranie znowu tego get_child()
		child[k].queue_free()
		child.pop_at(0)
		#k += 1

	for i in range(0,child.size(),1):
		child[i].timeValue.text = str(mainControl.inProgressBuild[i].timeToBuild)
		
	pass # Replace with function body.
