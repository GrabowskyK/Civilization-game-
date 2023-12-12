extends Node2D

@onready var textureKnight = $Texture
@onready var console = $"../Console/Text"
@onready var popupMenu = $PopupMenu

var health : int = 10
var attack : int = 1
var defense : int = 1
var movePoints : int = 1
var texture_ = preload("res://army/farner.png")
var player = "Gracz A"

var isSelected = false
var mouseEntered = false

signal GetLocalTileMap

func setStats(Attack, Defense, MovePoints, Player):
	attack = Attack
	defense = Defense
	movePoints = MovePoints
	player = Player

func _ready():
	textureKnight.texture = texture_
	info()
	# Utwórz wojownika z domyślnymi wartościami ataku=1, obrony=1
	

func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if(isSelected == true):
		if(Input.is_action_pressed("wUp")):
			self.position.y = position.y - 64
		if(Input.is_action_pressed("sDown")):
			self.position.y = position.y + 64
		if(Input.is_action_pressed("aLeft")):
			self.position.x = position.x - 64
		if(Input.is_action_pressed("dRight")):
			self.position.x = position.x + 64
	if(mouseEntered == true and event.is_action_pressed("click")):
		isSelected = true
	if(event.is_action_pressed("left")):
		isSelected = false
	if(event.is_action_pressed("right_click") and mouseEntered == true):
		emit_signal("GetLocalTileMap")
		popupMenu.popup(Rect2i(get_window().get_mouse_position().x,get_window().get_mouse_position().y,100,100))
	
func info():
	print("Attack: ", attack, "Defense: ", defense)


func _on_mouse_entered() -> void:
	mouseEntered = true
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	mouseEntered = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	print(str(area.attack) + " " + str(self.attack))
	if(self.attack < area.attack):
		area.health = area.health - self.attack
		console.text = console.text + "\n" + str(area.player) + " pokonał jednostke," + str(self.player) + "\n" + "zostawił " + str(area.health) + " zdrowia"  
		self.queue_free()
	elif self.attack > area.attack:
		self.health = self.health - area.attack
		console.text = console.text + "\n" + str(self.player) + " pokonał jednostke," + str(area.player) + "\n" + "zostawił " + str(self.health) + " zdrowia" 
		area.queue_free()
		
	pass # Replace with function body.



signal CreateCastle
func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		popupMenu.PopupIds.move:
			print("move")
		popupMenu.PopupIds.createCastle:
			print("CreateCastle")
			emit_signal("CreateCastle")
		popupMenu.PopupIds.createFarm:
			print("createFarm")
		popupMenu.PopupIds.createRoad:
			print("createRoad")
		popupMenu.PopupIds.exit:
			print("Exit")
	pass # Replace with function body.
