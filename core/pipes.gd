class_name Pipes
extends Node2D

signal player_entered
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const SPEED := 100.0

func _physics_process(delta: float) -> void:
	move_local_x(-SPEED * delta)


func _on_area_2d_player_entered(body: Node2D) -> void:
	if body is Player:
		audio_stream_player.play()
		player_entered.emit()
