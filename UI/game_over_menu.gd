extends Control

signal game_restarted

func _on_button_pressed() -> void:
	game_restarted.emit()
