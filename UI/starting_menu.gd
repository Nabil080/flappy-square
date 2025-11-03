extends Control

func _ready() -> void:
	show()
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	hide()
	$"../../Player".is_playing = true
	Globals.first_launch = false
