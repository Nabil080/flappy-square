extends ParallaxBackground

@export var scroll_speed := 100.0  # pixels per second

func _process(delta: float) -> void:
	scroll_offset.x -= scroll_speed * delta
