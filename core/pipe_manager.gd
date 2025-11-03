extends Node2D

signal player_entered

const PIPES = preload("uid://bmkwntdta7k0t")
const MAX_DIST := 50.0
const MAX_PIPES := 5
const SPAWN_INTERVAL := 1.5

@onready var game: Node2D = $".."

var pool: Array[Pipes] = []
var active_pipes: Array[Pipes] = []


func _ready() -> void:
	_spawn_loop()


func reset():
	# Hide and disable physics on all active pipes
	for pipes in active_pipes:
		_deactivate_pipe(pipes)
		pool.append(pipes)
	active_pipes.clear()


func _spawn_loop() -> void:
	while true:
		if not get_tree().paused:
			_spawn_pipe_from_pool()
		await get_tree().create_timer(SPAWN_INTERVAL).timeout


func _spawn_pipe_from_pool() -> void:
	var pipes: Pipes
	if pool.is_empty():
		pipes = _new_pipes()
	else:
		pipes = pool.pop_back()

	# Reactivate
	_activate_pipe(pipes)
	pipes.global_position = global_position
	pipes.move_local_y(randf_range(-MAX_DIST, MAX_DIST))
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
