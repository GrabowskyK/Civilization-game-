extends GridContainer
@onready var mainNode = $"../../../../../../.."
var newInstance 
var jednostkiLvl1 : Array = [Farmer.new(), Knight.new(),Archer.new(),Husarz.new(), Assasin.new()]
var jednostkiLvl2 : Array = [STFarmer.new(), STKnight.new(), STArcher.new(), STJedi.new(), STYoda.new(), STFourSwords.new()]

#Tablica sluzy do ładowania jednostek w zależnośći od cywilzacji. TO smao dla budynków
var unitsCivi : Array = [jednostkiLvl1,jednostkiLvl2]
var units : Array = []

var jednostkaArmy : PackedScene = preload("res://Castle/Control/type_army.tscn") 

var parent 
var i = 0
func _ready() -> void:
	parent = mainNode.get_parent()
	units = unitsCivi[parent.player.numberCivilization]
	for item in units:
		newInstance = jednostkaArmy.instantiate()
		newInstance.connect("CreateJednostka",_CreateUnit)
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

signal SentUnitToProgress(unitObject)

#Funkcja, która sprawdza czy jest wystarczająco środków aby stworzyć unit
func _CreateUnit(jednostka):
	var parent = mainNode.get_parent()
	var unit = units[jednostka]
	if parent.player.gold < unit.cost:
		print("Masz za mało surowców")
	else:
		parent.player.gold -= unit.cost
		mainNode.totalGold.text = str(parent.player.gold)
		mainNode.inProgressArmy.append(unit.duplicate())
		#Wysyła unit do progressu
		emit_signal("SentUnitToProgress",unit.duplicate())
	
func RefreshUnitView():
	#Gdy bedzie 4 budynki itd to zakutaliozuj do budynkilvl2
	for child in get_children():
		child.queue_free()
	units = unitsCivi[parent.player.numberCivilization]
	var i = 0
	for item in units:
		newInstance = jednostkaArmy.instantiate()
		newInstance.connect("CreateJednostka",_CreateUnit)
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
