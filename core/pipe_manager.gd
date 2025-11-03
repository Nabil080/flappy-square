extends Node2D

const PIPES = preload("uid://bmkwntdta7k0t")
const MAX_DIST := 32.0
var count := 0

func _on_destroy_area_area_entered(area: Area2D) -> void:
	var pipes : Pipes = area.get_parent()
	pipes.position = position
	pipes.move_local_y(randf_range(-MAX_DIST, MAX_DIST))
