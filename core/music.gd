extends AudioStreamPlayer


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_music"):
		toggle_music()
	if Input.is_action_just_pressed("toggle_sfx"):
		toggle_sfx()

func toggle_music():
	_toggle_bus("Music")

func toggle_sfx():
	_toggle_bus("sfx")

func _toggle_bus(bus_name := "Master"):
	var _bus := AudioServer.get_bus_index(bus_name)
	var is_muted := AudioServer.is_bus_mute(_bus)
	AudioServer.set_bus_mute(_bus, not is_muted)
