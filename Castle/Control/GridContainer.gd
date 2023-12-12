extends GridContainer
var newInstance 
var jednostkiLvl1 : Array = [Farmer.new(), Knight.new(),Archer.new(),Husarz.new(), Assasin.new()]
var jednostkaArmy : PackedScene = preload("res://Castle/Control/type_army.tscn") 
func _ready() -> void:
	for item in jednostkiLvl1:
		newInstance = jednostkaArmy.instantiate()
		add_child(newInstance) 
		newInstance.nameValue.text = item.nameArmy
		newInstance.healthValue.text = str(item.health)
		newInstance.attackValue.text = str(item.attack)
		newInstance.defendValue.text = str(item.defense)
		newInstance.moveValue.text = str(item.movePoints)
		newInstance.costValue.text = str(item.cost)
		newInstance.opisValue.text = str(item.opis)
		newInstance.textureValue.texture = load(item._texture)
	pass
