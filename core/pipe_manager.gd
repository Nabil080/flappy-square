extends Node2D

signal player_entered

const PIPES = preload("uid://bmkwntdta7k0t")
const MAX_DIST := 50.0           # Tunnel distance from the center
const MAX_PIPES := 5             # Pool size
const SPAWN_INTERVAL := 1.5      # seconds between spawns

@onready var game: Node2D = $".."

var pool: Array[Pipes] = []      # inactive pipe pool

func _ready() -> void:
	_spawn_loop()
	
func reset():
	for pipes in get_tree().get_nodes_in_group("pipes"): pipes.free()

func _spawn_loop() -> void:
	while true:
		if not get_tree().paused:
			_spawn_pipe_from_pool()
		await get_tree().create_timer(SPAWN_INTERVAL).timeout

func _spawn_pipe_from_pool() -> void:
	var pipes: Pipes = pool.pop_back()
	if not pipes:
		pipes = _new_pipes()
	pipes.global_position = global_position
	randomize()
	pipes.move_local_y(randf_range(-MAX_DIST, MAX_DIST))

func _new_pipes() -> Pipes:
	print("Creating new pipe")
	var pipes: Pipes = PIPES.instantiate()
	pipes.connect("player_entered", _on_player_entered)
	add_child(pipes)
	return pipes

func _on_destroy_area_area_entered(area: Area2D) -> void:
	# When a pipe enters the destroy area, recycle it
	var pipes: Pipes = area.get_parent()
	pool.append(pipes)

func _on_player_entered():
	player_entered.emit()
