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
var movement = 100

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
	mainNode = get_parent()
	unitFlag.texture = load(flagTexture)
	healthBar.min_value = 0
	healthBar.max_value = health
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
			
		if(event.is_action_pressed("right_click") and mouseEntered == true):
			emit_signal("SelectNodeToCreatePath",self)
			current_point_path.clear()
			rememberPoints.clear()
			emit_signal("GetLocalTileMap")
			popupMenu.popup(Rect2i(get_window().get_mouse_position().x,get_window().get_mouse_position().y,100,100))
			makeMove = false
		elif event.is_action_pressed("right_click") and mouseEntered == false:
			isSelected = false
			is_moving = false
			makeMove = false
			if !current_point_path.is_empty():
				rememberPoints = current_point_path.duplicate()
			current_point_path.clear()
			
		if event is InputEventMouseButton and event.double_click and isSelected:
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
			self.position = area.position
			self.isEntered = true
			area.isEntered = true
			var fightSystemPath = preload("res://FightSystem/fight_system.tscn")
			var fightNode = fightSystemPath.instantiate()
			fightNode.unit1 = self
			fightNode.unit2 = area
			add_child(fightNode)
			await(get_tree().create_timer(1).timeout)
			await(fightNode.fightSystem())
			var result = fightNode.RemoveUnit()
			if result == self:
				self.health = result.health
				self.healthValue.text = str(result.health)
				self.healthBar.value = result.health
				self.isEntered = false
				if area is CastleClass:
					area.player.castles.pop_at(player.castles.find(area,0))
				else:
					area.player.units.pop_at(player.units.find(area,0))
				area.queue_free()
			else:
				area.health = result.health
				area.healthValue.text = str(result.health)
				area.healthBar.value = result.health
				area.isEntered = false
				if self.area is CastleClass:
					self.player.castles.pop_at(player.castles.find(area,0))
				else:
					self.player.units.pop_at(player.units.find(area,0))
				self.queue_free()
			
			fightNode.queue_free()
	get_parent()._IsPlayerDefeted()
	pass # Replace with function body.


func _on_popup_menu_id_pressed(id: int) -> void:
	match id:
		popupMenu.PopupIds.move:
			print("move")
			isSelected = true
		popupMenu.PopupIds.createCastle:
			print("CreateCastle")
			emit_signal("CreateCastle")
		popupMenu.PopupIds.createFarm:
			emit_signal("CreateFarm")
		popupMenu.PopupIds.createRoad:
			print("createRoad")
		popupMenu.PopupIds.exit:
			print("Exit")
	pass

func _process(delta: float) -> void:
	if current_id_path.is_empty():
		makeMove = false
		return 
	elif makeMove == true and isSelected == true:
		if is_moving == false:
			print(mainNode)
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

