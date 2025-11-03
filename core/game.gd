extends Node2D

@onready var score_label: Label = $UI/Score
var score := 0

func _on_player_is_dead() -> void:
	get_tree().paused = true 

func _on_pipe_manager_player_entered() -> void:
	score += 1
	_update_ui()

func _update_ui():
	score_label.text = str(score)
