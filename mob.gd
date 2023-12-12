extends Area2D

@onready var sprite2D = $Sprite2D
@onready var collisionShape = $CollisionShape2D

var health = 100
var attack = 0
var is_selected = false
var isMouseOn = false
var movement

signal test
signal jakiObiekt(Node)

func _ready() -> void:
	attack = randi_range(10,24)
	movement = Vector2(position.x, position.y)
	pass # Replace with function body.


func _process(delta: float) -> void:
	
	if(is_selected):
		sprite2D.modulate = Color(0,0,1)
		if Input.is_action_pressed("right"):
			movement.x += 10
		if Input.is_action_pressed("left"):
			movement.x -= 10
		if Input.is_action_pressed("down"):
			movement.y += 10
		if Input.is_action_pressed("up"):
			movement.y -= 10
	else:
		sprite2D.modulate = Color(255,255,255)
	# Przemnóż wektor ruchu przez prędkość i delta, a następnie przesuń postać
	position = Vector2(movement.x,movement.y)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("click") and isMouseOn and event.pressed):
		emit_signal("jakiObiekt",self)
		#print("emituje", self)
		is_selected = true
		health = 30
	elif(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)): # or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
		is_selected = false
	
	

func ChangePostionChild(vector2 : Vector2):
	#print("Vector przekazany", vector2)
	sprite2D.position = vector2
	collisionShape.position = vector2

func _on_mouse_entered() -> void:
	isMouseOn = true

func _on_mouse_exited() -> void:
	isMouseOn = false

func _on_area_entered(area: Area2D) -> void:
	print(area)
	pass # Replace with function body.
