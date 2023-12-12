extends Node2D

@onready var sprite = $Sprite2D
#@onready var mob = $"../Mob"

var attack = 0
var movement = Vector2(0,0)
var i = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack = randi_range(25,26)
	
	#sprite.texture = ResourceLoader.load("res://army/a.png")
	
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if Input.is_action_pressed("right"):
		movement.x += 10
	if Input.is_action_pressed("left"):
		movement.x -= 10
	if Input.is_action_pressed("down"):
		movement.y += 10
	if Input.is_action_pressed("up"):
		movement.y -= 10

	# Przemnóż wektor ruchu przez prędkość i delta, a następnie przesuń postać
	position = Vector2(movement.x,movement.y)



func _on_mouse_entered() -> void:
	sprite.flip_h = !sprite.flip_h
	print(position)
	position.x = 30 * i
	position.y = 30 * i
	i += 1
	pass # Replace with function body.


func _on_sprite_2d_texture_changed() -> void:
	print("Zmieniono texture")
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	print("XD")
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	var mob_name = area.name
	var mob = area.get_node("../" + mob_name)
	print(attack, mob.attack)
#	if(attack > mob.attack):
#		mob.queue_free()
#	else:
#		queue_free()
