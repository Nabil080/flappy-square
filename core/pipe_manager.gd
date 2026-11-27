extends Node2D

signal player_entered

@onready var player: Player = $"../Player"
const PIPES = preload("uid://bmkwntdta7k0t")

const MIN_INTERVAL := 0.5
const MAX_INTERVAL := 2.0
const MAX_Y_DIST := 64.0

# Keeps the gap away from the floor and ceiling
const MIN_Y := 0.0 + 64.0
const MAX_Y := 180.0 - 64.0

var pool: Array[Pipes] = []
var active_pipes: Array[Pipes] = []
var last_pipe_y := (MIN_Y + MAX_Y) / 2.0


func _ready() -> void:
	_spawn_loop()


func reset() -> void:
	for pipes in active_pipes:
		_deactivate_pipe(pipes)
		pool.append(pipes)
	active_pipes.clear()
	last_pipe_y = (MIN_Y + MAX_Y) / 2.0


func _spawn_loop() -> void:
	while true:
		if not get_tree().paused and player.is_playing:
			_spawn_pipe_from_pool()

		var interval = randf_range(MIN_INTERVAL, MAX_INTERVAL)
		await get_tree().create_timer(interval).timeout


func _spawn_pipe_from_pool() -> void:
	var pipes: Pipes
	if pool.is_empty():
		pipes = _new_pipes()
	else:
		pipes = pool.pop_back()

	_activate_pipe(pipes)

	# The bigger the random interval, the further the gap can move from the last one
	var interval = randf_range(MIN_INTERVAL, MAX_INTERVAL)
	var t = (interval - MIN_INTERVAL) / (MAX_INTERVAL - MIN_INTERVAL)
	var max_dist = t * MAX_Y_DIST

	var new_y = last_pipe_y + randf_range(-max_dist, max_dist)

	new_y = clamp(new_y, MIN_Y, MAX_Y)
	last_pipe_y = new_y

	pipes.global_position = Vector2(global_position.x, new_y)
	active_pipes.append(pipes)


func _new_pipes() -> Pipes:
	var pipes: Pipes = PIPES.instantiate()
	pipes.connect("player_entered", _on_player_entered)
	add_child(pipes)
	return pipes


func _on_destroy_area_area_entered(area: Area2D) -> void:
	var pipes: Pipes = area.get_parent()
	if pipes in active_pipes:
		active_pipes.erase(pipes)
		_deactivate_pipe(pipes)
		pool.append(pipes)


func _deactivate_pipe(pipes: Node2D) -> void:
	pipes.visible = false
	pipes.process_mode = Node.PROCESS_MODE_DISABLED

	for child in pipes.get_children():
		if child is StaticBody2D:
			child.set_deferred("collision_layer", 0)
			child.set_deferred("collision_mask", 0)
		elif child is Area2D:
			child.monitoring = false
			child.set_deferred("collision_layer", 0)
			child.set_deferred("collision_mask", 0)


func _activate_pipe(pipes: Node2D) -> void:
	pipes.visible = true
	pipes.process_mode = Node.PROCESS_MODE_INHERIT

	for child in pipes.get_children():
		if child is StaticBody2D:
			child.set_deferred("collision_layer", 1)
			child.set_deferred("collision_mask", 1)
		elif child is Area2D:
			child.monitoring = true
			child.set_deferred("collision_layer", 1)
			child.set_deferred("collision_mask", 1)


func _on_player_entered():
	player_entered.emit()
