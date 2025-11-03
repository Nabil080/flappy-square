extends Control

@onready var sfx_button: TextureButton = $SfxButton
@onready var music_button: TextureButton = $MusicButton

func _on_music_button_toggled(toggled_on: bool) -> void:
	Input.action_press("toggle_music")
	Input.action_release("toggle_music")

	music_button.self_modulate.a = 1.0 if toggled_on else 0.4  # full or dim


func _on_sfx_button_toggled(toggled_on: bool) -> void:
	Input.action_press("toggle_sfx")
	Input.action_release("toggle_sfx")

	sfx_button.self_modulate.a = 1.0 if toggled_on else 0.4
