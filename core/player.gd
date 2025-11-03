extends RigidBody2D

const JUMP_IMPULSE := 200.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		print("hi")
		apply_central_impulse(Vector2(0, -JUMP_IMPULSE))
