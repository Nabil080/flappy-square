extends Node2D

var score := 0

func _on_player_is_dead() -> void:
	get_tree().paused = true 

func _on_pipe_manager_player_entered() -> void:
	score += 1
	print("player entered, new score : ", score)
