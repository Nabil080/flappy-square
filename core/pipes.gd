class_name Pipes
extends Node2D

signal player_entered
const SPEED := 100.0

func _physics_process(delta: float) -> void:
	move_local_x(-SPEED * delta)


func _on_area_2d_player_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit() 
