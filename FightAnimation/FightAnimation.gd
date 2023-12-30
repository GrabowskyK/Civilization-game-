extends Control

@onready var tile1 = $ColorRect
@onready var tile2 = $ColorRect2
@onready var texture1 = $ColorRect/TextureRect
@onready var texture2 = $ColorRect2/TextureRect2
var tempUnit1
var tempUnit2
var result = 0
var rectSize

func _ready() -> void:
	rectSize = get_viewport_rect()
	tile1.position = Vector2(-rectSize.size.x/2,100)
	tile2.position = Vector2(rectSize.size.x,100)
	
func _process(delta: float) -> void:
	result += 1
	if(tile1.position.x < 0):
		tile1.position = Vector2(tile1.position.x + result, 100)
	if(tile2.position.x > rectSize.size.x/2):
		tile2.position = Vector2(tile2.position.x - result, 100)
	pass
	
func PassTheUnits(unit1, unit2):
	tempUnit1 = unit1
	tempUnit2 = unit2
	texture1 = unit1.textureKnight.texture
	texture2 = unit2.textureKnight.texture
	
