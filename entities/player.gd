class_name Player
extends CharacterBody2D

signal is_dead

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var mesh_instance_2d: MeshInstance2D = $MeshInstance2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var GRAVITY := 800.0
@export var FLAP_STRENGTH := 225.0

var can_play : bool = false
var alive : bool = true
var is_playing : bool
var should_fall : bool

var STARTING_POSITION : Vector2

func _ready() -> void:
	STARTING_POSITION = global_position
	reset()
	
func reset():
	global_position = STARTING_POSITION
	can_play = true
	alive = true
	is_playing = false
	should_fall = false
	velocity = Vector2.ZERO
	mesh_instance_2d.rotation = 0.0
	mesh_instance_2d.modulate = Color.WHITE
	collision_shape_2d.disabled = false
	point_light_2d.enabled = true

func _physics_process(delta):
	# Apply GRAVITY 
	if is_playing or should_fall:
		velocity.y += GRAVITY * delta

	# Flap
	if (can_play and alive and
		(Input.is_action_just_pressed("flap") or
		Input.is_action_just_pressed("mouse_flap") and not _is_over_ui())
		):
		is_playing = true
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
	mesh_instance_2d.rotation = lerp(mesh_instance_2d.rotation, target_rotation, 0.1)

func _manage_collision(collision: KinematicCollision2D):
	if is_playing and collision.get_collider().is_in_group("enemy"):
		print("Player died")
		mesh_instance_2d.modulate = Color.RED
		collision_shape_2d.disabled = true
		point_light_2d.enabled = false
		is_playing = false
		should_fall = true
		velocity.y = -FLAP_STRENGTH
		alive = false
		is_dead.emit()


func _is_over_ui() -> bool:
	var hovered = get_viewport().gui_get_hovered_control()
	print(hovered)
	return hovered != null and hovered.name != "UI"
