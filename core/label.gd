extends Label

@onready var player: Player = $"../../Player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(not player.is_playing and player.can_play)
	if not player.is_playing and player.can_play:
		show()
	else:
		hide()
