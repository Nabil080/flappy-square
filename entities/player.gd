class_name Player
extends CharacterBody2D

signal is_dead

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var GRAVITY := 800.0
@export var FLAP_STRENGTH := 225.0

var can_jump := true

func _physics_process(delta):
	# Apply GRAVITY
	velocity.y += GRAVITY * delta

	# Flap
	if Input.is_action_just_pressed("flap") and can_jump:
		velocity.y = -FLAP_STRENGTH
		audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
		audio_stream_player.play()

	# Move and collide
	var collision := move_and_collide(velocity * delta)
	if collision:
		_manage_collision(collision)
	

	# Rotate smoothly based on vertical speed
	var vertical_speed := velocity.y
	var tilt_in_degrees := clampf(vertical_speed / 4.0, -30.0, 90.0)
	var target_rotation  := deg_to_rad(tilt_in_degrees)
	rotation = lerp(rotation, target_rotation, 0.1)

func _manage_collision(collision: KinematicCollision2D):
	if collision.get_collider().is_in_group("enemy"):
		$MeshInstance2D.modulate = Color.DARK_RED
		$CollisionShape2D.disabled = true
		velocity.y = -FLAP_STRENGTH
		can_jump = false
		is_dead.emit()
