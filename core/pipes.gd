extends Node2D

const SPEED := 150.0

func _physics_process(delta: float) -> void:
	move_local_x(-SPEED * delta)
