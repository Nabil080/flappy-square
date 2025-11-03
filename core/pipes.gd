class_name Pipes
extends Node2D

const SPEED := 100.0

func _physics_process(delta: float) -> void:
	move_local_x(-SPEED * delta)
