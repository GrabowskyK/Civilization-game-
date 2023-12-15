extends Node2D

@onready var player = $"../Player"
var timerVar = 0

func _process(delta):
	queue_redraw()

func _draw():
	if player.current_point_path.is_empty():
		return

	# Ustaw kolory dla punktów
	var colors = []
	for i in range(player.current_point_path.size()):
		if i < player.movement:
			colors.append(Color(0, 1, 0))  # Ustaw kolor dla pierwszych 10 punktów na zielony
		else:
			colors.append(Color(1, 0, 0))  # Ustaw kolor dla pozostałych punktów na czerwony

	# Rysuj odcinki z odpowiednimi kolorami
	for i in range(player.current_point_path.size() - 1):
		draw_line(player.current_point_path[i], player.current_point_path[i + 1], colors[i], 2)

func _on_player_delete_line() -> void:
	player.current_point_path.remove_at(0)
	pass # Replace with function body.


func _on_button_pressed() -> void:
	player.make = false
	player.movement = 10
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	player.make = true
	pass # Replace with function body.
