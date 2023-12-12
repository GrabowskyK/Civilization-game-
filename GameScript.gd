extends Node2D

#do dlete
@onready var mob = $Mob
@onready var mob2 = $Mob2
@onready var map = $MapaGD
@onready var archer = $Area2D

#variable global
var tileSize = 128 #zmienna odpowiedzialna za wielkosc kafla


var x = 40
var y = 40
var mouse_position
var mob_scene = load("res://mob.tscn")
var currentSelectedMob

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var mobNodes = get_tree().get_nodes_in_group("mobs")
	for i in mobNodes:
		i.jakiObiekt.connect(_on_mob_jaki_obiekt)
	
	map.Attack.connect(_on_attack)
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	
	
func _input(event: InputEvent):
	mouse_position = get_global_mouse_position()
#	if(currentSelectedMob != null and currentSelectedMob.is_selected):
#		if(event.is_action_pressed("right_click") and map.openPopup == true):
#			var newMobPosition = Vector2(0,0)
#			#print("Local", map.local_position)
#			newMobPosition.x = map.local_position.x * tileSize + tileSize/2
#			newMobPosition.y = map.local_position.y * tileSize + tileSize/2
#			#print("New mob position", newMobPosition)
#			currentSelectedMob.ChangePostionChild(newMobPosition)


func _on_mob_jaki_obiekt(node) -> void:
	currentSelectedMob = node 
	pass # Replace with function body.



func _on_mapa_gd_move(vector2Position) -> void:
	var newMobPosition = Vector2(0,0)
	#print("Local", map.local_position)
	newMobPosition.x = vector2Position.x * tileSize + tileSize/2
	newMobPosition.y = vector2Position.y * tileSize + tileSize/2
	#print("New mob position", newMobPosition)
	currentSelectedMob.ChangePostionChild(newMobPosition)
	pass # Replace with function body.

func _on_attack(vector2):
	currentSelectedMob.attack
	pass

