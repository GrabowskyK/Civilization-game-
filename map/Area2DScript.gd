extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var local = event.position
		if get_viewport_rect().has_point(mouse_pos):
			print("Clicked on the image!")
			# Tutaj możesz wywołać dowolne akcje po kliknięciu na obrazek
	pass # Replace with function body.
