extends Node2D

const SAVE_PATH := "user://savegame.json"

@onready var game_over_menu: Control = $UI/GameOverMenu
@onready var score_label: Label = $UI/Score
var score := 0
var best_score := 0


func _ready() -> void:
	_load_data()
	_update_ui()


func _on_player_is_dead() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	game_over_menu.show()
	_save_data()


func _on_pipe_manager_player_entered() -> void:
	score += 1
	_update_ui()


func _update_ui() -> void:
	score_label.text = "Score: %d\nBest: %d" % [score, best_score]


func _save_data() -> void:
	# Only save if it’s a new best score
	if score < best_score:
		return
	best_score = score
	var data := {"best_score": best_score}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()


func _load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		best_score = 0
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		best_score = 0
		return

	var content := file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if typeof(result) == TYPE_DICTIONARY and result.has("best_score"):
		best_score = result["best_score"]
	else:
		best_score = 0
