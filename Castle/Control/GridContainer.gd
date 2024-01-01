extends GridContainer
@onready var mainNode = $"../../../../../../.."
var newInstance 
var jednostkiLvl1 : Array = [Farmer.new(), Knight.new(),Archer.new(),Husarz.new(), Assasin.new()]
var jednostkaArmy : PackedScene = preload("res://Castle/Control/type_army.tscn") 

var i = 0
func _ready() -> void:
	for item in jednostkiLvl1:
		newInstance = jednostkaArmy.instantiate()
		newInstance.connect("CreateJednostka",test)
		add_child(newInstance)
		newInstance.number = i
		newInstance.nameValue.text = item.nameArmy
		newInstance.healthValue.text = str(item.health)
		newInstance.attackValue.text = str(item.attack)
		newInstance.defendValue.text = str(item.defense)
		newInstance.moveValue.text = str(item.movePoints)
		newInstance.costValue.text = str(item.cost)
		newInstance.opisValue.text = str(item.opis)
		newInstance.textureValue.texture = load(item._texture)
		i += 1
	pass

signal CreateKnightFromCastle(jednostkaType)
signal SentUnitToProgress(unitObject)
func test(jednostka):
	#mainNode.inProgressArmy.append(jednostka)
	emit_signal("SentUnitToProgress",jednostkiLvl1[jednostka].duplicate())
	#emit_signal("CreateKnightFromCastle",jednostkiLvl1[jednostka])
	

