extends Node2D

func _on_player_is_dead() -> void:
	get_tree().paused = true 
