extends Node2D

@onready var textureKnight = $Texture
@onready var console = $"../Console/Text"
@onready var popupMenu = $PopupMenu
@onready var map = $"../TileMap" #do rysowania poruszania sie 
@onready var healthBar = $TextureProgressBar
@onready var healthValue = $TextureProgressBar/healthValue
@onready var unitFlag = $Texture/TextureRect

var isEntered = false

var player : PlayerClass
var jednostkaName : String
var health : int = 10
var maxHealth : int 
var attack : int = 1
var defense : int = 1
var movePoints : int = 1
var texture_ = preload("res://army/farner.png")
var mainNode

var id_path
var isSelected = false
var mouseEntered = false
var flagTexture = ""
#mapa
var makeMove = false
var astargrid : AStarGrid2D
var current_id_path: Array[Vector2i]
var target: Vector2
var is_moving: bool
var current_point_path: PackedVector2Array
var rememberPoints: PackedVector2Array
var movement = 0

signal GetLocalTileMap
signal CreateCastle
signal CreateFarm
signal DeleteLine
signal SelectNodeToCreatePath(knightNode)

func Create(jednostka : TypeArmy, currentPlayer):
	jednostkaName = jednostka.nameArmy
	attack = jednostka.attack
	defense = jednostka.defense
	health = jednostka.health
	movePoints = jednostka.movePoints
	texture_ = jednostka._texture
	player = currentPlayer
	flagTexture = currentPlayer.playerFlag

func _ready():
	maxHealth = health
	mainNode = get_parent()
	unitFlag.texture = load(flagTexture)
	healthBar.min_value = 0
	healthBar.max_value = maxHealth
	healthValue.text = str(health) + "/" + str(healthBar.max_value)
	textureKnight.texture = load(texture_)
	astargrid = AStarGrid2D.new()
	astargrid.region = map.get_used_rect()
	astargrid.cell_size = Vector2(64,64)
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	
	for x in map.get_used_rect().size.x:
		for y in map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + map.get_used_rect().position.x,
				y + map.get_used_rect().position.y)

			var tile_data = map.get_cell_tile_data(0, tile_position)

			if(tile_data == null or tile_data.get_custom_data("walkable") == false):
				astargrid.set_point_solid(tile_position)

	
func _input(event: InputEvent) -> void:
	if player == get_parent().currentPlayer:
		if(mouseEntered == true and event.is_action_pressed("click") and !rememberPoints.is_empty()):
			emit_signal("SelectNodeToCreatePath",self)
			isSelected = true
			current_point_path = rememberPoints.duplicate()
			mainNode.camera.input_vector = position
			
		if(event.is_action_pressed("right_click") and mouseEntered == true):
			emit_signal("SelectNodeToCreatePath",self)
			current_point_path.clear()
			rememberPoints.clear()
			emit_signal("GetLocalTileMap")
			mainNode.camera.input_vector = position
			popupMenu.popup(Rect2i(get_window().get_mouse_position().x,get_window().get_mouse_position().y,100,100))
			makeMove = false
		elif event.is_action_pressed("right_click") and mouseEntered == false:
			CheckIfIsOnGoodTile()
			isSelected = false
			is_moving = false
			makeMove = false	
			if !current_point_path.is_empty():
				rememberPoints = current_point_path.duplicate()
			current_point_path.clear()

		#Ostatnia rzecz w tym ifie sprawdza czy kliknięto na obiekt po którym się nei da chodzić
		if event is InputEventMouseButton and event.double_click and isSelected and map.get_cell_tile_data(0, map.local_to_map(get_global_mouse_position())).get_custom_data("walkable") == true:
			makeMove = true
			
		if event is InputEventMouse and isSelected == true and makeMove == false and rememberPoints.is_empty():
			if is_moving:
				id_path = astargrid.get_id_path(
					map.local_to_map(global_position),
					map.local_to_map(get_global_mouse_position())			
				)
			else:
				id_path = astargrid.get_id_path(
					map.local_to_map(global_position),
					map.local_to_map(get_global_mouse_position())			
				)
			id_path.pop_front()
			
			if id_path.is_empty() == false:
				current_id_path = id_path
			current_point_path = astargrid.get_point_path(
					map.local_to_map(global_position),
					map.local_to_map(get_global_mouse_position())
				)

			for i in current_point_path.size():
				current_point_path[i] = current_point_path[i] + Vector2(32,32)

func _on_mouse_entered() -> void:
	mouseEntered = true
	healthBar.visible = true
	pass # Replace with function body.

func _on_mouse_exited() -> void:
	mouseEntered = false
	healthBar.visible = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	if self.player != area.player:
		if self.isEntered == false and area.isEntered == false:
			self.makeMove = false
			self.isSelected = false
			self.isEntered = true # Pozwala na to, że wywołuje się tylko raz model walki
			self.current_point_path = [] 
			area.isEntered = true
			var fightSystemPath = preload("res://FightSystem/fight_system.tscn") # Stworzenie sceny walki
			var fightNode = fightSystemPath.instantiate() 
			# Przekazanie do sceny jednostek
			fightNode.unit1 = self 
			fightNode.unit2 = area
			add_child(fightNode)
			await(get_tree().create_timer(1).timeout) # Czeka 1 sekunde zanim się wykona dalsza część kodu
			await(fightNode.fightSystem()) # Czeka aż cała funkcja fightSystem() dobiegnie końca
			var result = fightNode.RemoveUnit() # Zwracana wartość ze sceny
			if result == self:
				self.health = result.health
				self.healthValue.text = str(result.health) + "/" + str(self.maxHealth)
				self.healthBar.value = result.health
				self.isEntered = false
				if area is CastleClass: # Sprawdza czy zatakowany obiekt to zamek
					var index = area.player.castles.find(area,0)
					area.player.castles.pop_at(index)
					player.infoText += "Jednostka " + self.jednostkaName + " (" + player.playerName +") zniszczyła zamek " + area.jednostkaName + " (" + area.player.playerName + "). Posiada " + str(self.health) + " HP.\n"
					get_parent().RefreshInfoConsole()
					map.set_cell(4,map.local_to_map(area.position),-1, Vector2(-1,-1)) # Usuwa zamek z mapy
					DeleteCastlesStatsFromPlayer(area)
				else:
					area.player.units.pop_at(player.units.find(area,0))
					player.infoText += "Jednostka " + self.jednostkaName + " (" + player.playerName +") pokonał/a " + area.jednostkaName + " (" + area.player.playerName + "). Posiada " + str(self.health) + " HP.\n"
					get_parent().RefreshInfoConsole()
				area.queue_free()
			else:
				area.health = result.health
				if area is CastleClass:
					area.health = result.health
				else:
					area.healthValue.text = str(result.health) + "/" + str(area.maxHealth)
					area.healthBar.value = result.health
				area.isEntered = false
				self.player.units.pop_at(player.units.find(self,0))
				area.player.infoText += "Jednostka " + area.jednostkaName + " ( " + area.player.playerName +" ) pokonał/a " + self.jednostkaName + " (" + self.player.playerName + "). Posiada " + str(area.health) + " HP.\n"
				player.infoText += "Jednostka " + area.jednostkaName + " ( " + area.player.playerName +" ) pokonał/a " + self.jednostkaName + " (" + self.player.playerName + "). Posiada " + str(area.health) + " HP.\n"
				get_parent().RefreshInfoConsole()
				self.queue_free()
			
			fightNode.queue_free()
	get_parent()._IsPlayerDefeted() # Sprwadza czy wszystkie zamki zostały zniszczone
	pass # Replace with function body.


func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		popupMenu.PopupIds.move:
			isSelected = true
		popupMenu.PopupIds.createCastle:
			emit_signal("CreateCastle")
			isSelected = false
		popupMenu.PopupIds.createFarm:
			emit_signal("CreateFarm")
			isSelected = false
		popupMenu.PopupIds.createRoad:
			print("createRoad")
			isSelected = false
		popupMenu.PopupIds.exit:
			print("Exit")
			isSelected = false
	pass

func _process(delta: float) -> void:
	if current_id_path.is_empty():
		makeMove = false
		return 
	elif makeMove == true and isSelected == true:
		mainNode.camera.input_vector = position
		if is_moving == false:
			target = map.map_to_local(current_id_path.front())
			is_moving = true
			
		if target != position and movement > 0:
			position = position.move_toward(target,10)
			mainNode.update_fog(position, player.fogTexture)
		elif target == position and movement > 0:
			current_id_path.pop_front()
			emit_signal("DeleteLine")
			movement -= 1
			is_moving = false
			
		if current_id_path.is_empty() == false:
			target = map.map_to_local(current_id_path.front())
		else:
			is_moving = false

func DeleteCastlesStatsFromPlayer(node):
	var player = node.player
	player.additionalAttack -= node.additionalAttack
	player.additionalDefense -= node.additionalDefense
	player.additionalFaith -= node.additionalFaith
	player.additionalFood -= node.additionalFoodIncome
	player.additionalGold -= node.additionalGoldIncome
	player.faith -= node.faith

#Żeby unit nie zatrzymywał się w losowych miejscach. Tylko niech dojdzie do kafelka i tam niech się zatrzyma
func CheckIfIsOnGoodTile():
	if isSelected == true and !current_id_path.is_empty() and is_moving == true and movement > 0:
		target = map.map_to_local(current_id_path.front())
		while target != position:
			position = position.move_toward(target,10)			
			mainNode.update_fog(position, player.fogTexture)
			await get_tree().create_timer(0.03).timeout
		current_id_path.pop_front()
		emit_signal("DeleteLine")
		movement -= 1
		is_moving = false

	
