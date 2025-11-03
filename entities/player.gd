extends CharacterBody2D

@export var gravity := 800.0
@export var flap_strength := 300.0

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta

	# Flap
	if Input.is_action_just_pressed("flap"):
		velocity.y = -flap_strength

	# Move and collide
	move_and_slide()

	# Rotate smoothly based on vertical speed
	var vertical_speed := velocity.y
	var tilt_in_degrees := clampf(vertical_speed / 4.0, -30.0, 90.0)
	var target_rotation  := deg_to_rad(tilt_in_degrees)
	rotation = lerp(rotation, target_rotation, 0.1)
