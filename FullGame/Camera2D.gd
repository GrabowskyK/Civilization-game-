extends Camera2D

@onready var tilemap = $"../TileMap"
@onready var game = $".." 
@onready var label = $Label
var cell_size = 64
var input_vector = Vector2(0,0)
var limitCamera
var marginCamera #Aby kamera nie jechała za daleko
var moveable : bool = true #Kiedy chce aby kamera była lub nie była w stanie się poruszać
var viewCameraSize

func _ready(): 
	var cell_size = 64 #Gdy mapa bedzie wieksza to sie zmieni wartość w rodzicu
	var numberOfTiles = tilemap.get_used_rect().size
	viewCameraSize = get_viewport_transform().origin
	limitCamera = (cell_size * numberOfTiles)/2
	limit_left = (-1 * numberOfTiles.x * cell_size)/2
	limit_right = (numberOfTiles.x * cell_size)/2
	limit_top = (-1 * numberOfTiles.y * cell_size)/2
	limit_bottom = (numberOfTiles.y * cell_size)/2

func _process(delta: float) -> void:
	if(moveable == true):
		if(abs(input_vector.x) < (limitCamera.x - (viewCameraSize.x/self.zoom.x) + (10/self.zoom.x))): #770
			if Input.is_action_pressed("right"):
				input_vector.x += 10
			if Input.is_action_pressed("left"):
				input_vector.x -= 10
		else:
			if input_vector.x < 0:
				input_vector.x = abs(limitCamera.x - (viewCameraSize.x/self.zoom.x) + (10/self.zoom.x)) * -1 + 1
			else:
				input_vector.x = limitCamera.x - (viewCameraSize.x/self.zoom.x) + (10/self.zoom.x) - 1

		if(abs(input_vector.y) < (limitCamera.y - (viewCameraSize.y/self.zoom.y) + (10/self.zoom.y))): #970
			if Input.is_action_pressed("down"):
				input_vector.y += 10
			if Input.is_action_pressed("up"):
				input_vector.y -= 10
		else:
			if input_vector.y < 0:
				input_vector.y =  abs(limitCamera.y - (viewCameraSize.y/self.zoom.y) + (10/self.zoom.y)) * -1 + 1
			else:
				input_vector.y = limitCamera.y - (viewCameraSize.y/self.zoom.y) + (10/self.zoom.y) - 1

		self.position = input_vector
		label.text = str(position)

func _input(event: InputEvent) -> void:
	if game.lockZooming == true:
		if Input.is_action_pressed("MouseWheelUP"):
			self.zoom = Vector2(self.zoom.x+0.5,self.zoom.y+0.5)
		if Input.is_action_pressed("MouseWheelDown"):
			self.zoom = Vector2(self.zoom.x-0.5,self.zoom.y-0.5)



