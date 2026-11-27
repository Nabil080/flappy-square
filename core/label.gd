extends Label

@onready var player: Player = $"../../Player"


func _process(_delta: float) -> void:
	if not player.is_playing and player.can_play:
		show()
	else:
		hide()
