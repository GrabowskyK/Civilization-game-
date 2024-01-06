extends CanvasLayer

@onready var vbox1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer
@onready var vbox2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer

var unit1 
var unit2 

@onready var flagUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/MarginContainer/TextureRect
@onready var nameUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/NameUnit
@onready var textureUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/TextureRect3
@onready var attackValueUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/HBoxContainer/attackValue
@onready var defenseValueUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/HBoxContainer2/defenseValue
@onready var healthUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/TextureProgressBar/healthValue
@onready var healthBarUnit1 = $PanelContainer/HBoxContainer/MarginContainer/ColorRect/VBoxContainer/TextureProgressBar


@onready var flagUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/MarginContainer/TextureRect
@onready var nameUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/NameUnit
@onready var textureUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/TextureRect3
@onready var attackValueUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/HBoxContainer/Label2
@onready var defenseValueUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/HBoxContainer2/Label2
@onready var healthBarUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/TextureProgressBar
@onready var healthUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/ColorRect/VBoxContainer/TextureProgressBar/healthValue

@onready var dmgToUnit1 = $PanelContainer/HBoxContainer/MarginContainer/dmgToUnit1
@onready var dmgToUnit2 = $PanelContainer/HBoxContainer/MarginContainer2/dmgToUnit2
var window 
var positionDmgToUnit1
var positionDmgToUnit2
var unitToDelete
func _ready() -> void:
	flagUnit1.texture = load(unit1.flagTexture)
	nameUnit1.text = unit1.jednostkaName
	textureUnit1.texture = load(unit1.texture_)
	healthBarUnit1.max_value = unit1.health
	healthBarUnit1.value = unit1.health
	healthUnit1.text = str(unit1.health)
	attackValueUnit1.text = str(unit1.attack)
	defenseValueUnit1.text = str(unit1.defense)
	
	flagUnit2.texture = load(unit2.flagTexture)
	nameUnit2.text = unit2.jednostkaName
	textureUnit2.texture = load(unit2.texture_)
	healthBarUnit2.max_value = unit2.health
	healthBarUnit2.value = unit2.health
	healthUnit2.text = str(unit2.health)
	attackValueUnit2.text = str(unit2.attack)
	defenseValueUnit2.text = str(unit2.defense)
	pass

func _process(delta: float) -> void:
	window = get_viewport().size
	if vbox1.position.x < window.x/4:
		vbox1.position.x += 15
		positionDmgToUnit1 = dmgToUnit1.position
		
	if vbox2.position.x > window.x/4 - vbox2.size.x:
		vbox2.position.x -= 15
		positionDmgToUnit2 = dmgToUnit2.position
		

func _on_button_pressed() -> void:
	self.queue_free()
	pass # Replace with function body.

func unitAnimation(unit):
	var previousPosition = unit.position
	for i in range(0,21,3):
		unit.position.x += i
		await(get_tree().create_timer(0.01).timeout)
	for i in range(0,21,3):
		unit.position.x -= i
		await(get_tree().create_timer(0.01).timeout)
	pass
	
func slide(dmgLabel):
	dmgLabel.visible = true
	dmgToUnit1.position = positionDmgToUnit1
	dmgToUnit2.position = positionDmgToUnit2
	for i in range(0,30,2):
		dmgLabel.position.y -= i
		await(get_tree().create_timer(0.02).timeout)
	dmgLabel.visible = false

func fightSystem():
	var tempAttackUnit1
	var tempAttackUnit2 
	var tempDefendUnit1
	var tempDefendUnit2
	while int(unit1.health) > 0 and int(unit2.health) > 0:
		tempAttackUnit1 = (unit1.attack + unit1.player.additionalAttack) * randf_range(0.8,1)
		tempAttackUnit2 = (unit2.attack + unit2.player.additionalAttack) * randf_range(0.8,1)
		tempDefendUnit1 = (unit1.defense + unit1.player.additionalDefense) * randf_range(0.8,1)
		tempDefendUnit2 = (unit2.defense + unit2.player.additionalDefense) * randf_range(0.8,1)
		
		var dmgUnit1 = ceil(tempAttackUnit1 - (tempAttackUnit1 * tempDefendUnit1/100))
		var dmgUnit2 = ceil(tempAttackUnit2 - (tempAttackUnit2 * tempDefendUnit2/100))
		await(unitAnimation(textureUnit1))
		unit2.health -= dmgUnit1
		dmgToUnit2.text = str(dmgUnit1)
		healthUnit2.text = str(unit2.health)
		healthBarUnit2.value = unit2.health
		await(slide(dmgToUnit2))
		if unit2.health > 0:
			await(unitAnimation(textureUnit2))
			unit1.health -= dmgUnit2
			healthBarUnit1.value = unit1.health
			healthUnit1.text = str(unit1.health)
			dmgToUnit1.text = str(dmgUnit2)
			await(slide(dmgToUnit1))
		#print("Unit1 attack:", tempAttackUnit1 - (tempAttackUnit1 * tempDefendUnit1/100), "Dmg:", dmgUnit1, " Health: ",unit1.health)
		#print("Unit2 attack", tempAttackUnit2 - (tempAttackUnit2 * tempDefendUnit2/100), "Dmg:", dmgUnit2, " Health: ", unit2.health)
		await(get_tree().create_timer(1).timeout)
	self.visible = false
	
func RemoveUnit():
	print(unit1.health)
	print(unit2.health)
	if unit1.health <= 0:
		unitToDelete = unit1
		return unit2
	else:
		unitToDelete = unit2
		return unit1

