extends Node2D

@export var max_speed: float = 200.0
@export var acceleration: float = 800.0
@export var deceleration: float = 800.0

@export var rotation_speed: float = 2.0
@export var rotation_smooth_speed: float = 1.0

@export var scale_step: float = 0.1
@export var min_scale: float = 0.5
@export var max_scale: float = 3.0
@export var scale_smooth_speed: float = 0.5

var velocity: Vector2 = Vector2.ZERO
var target_scale: Vector2
var target_rotation: float

func _ready():
	target_scale = scale
	target_rotation = rotation

func _process(delta):
	# Input vector
	var input_vector = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()

	# Accelerate or decelerate velocity
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

	# Update position by velocity
	global_position += velocity * delta

	# Rotation input
	if Input.is_action_pressed("Rotate"):
		target_rotation += rotation_speed * delta

	# Smooth rotation and scale
	rotation = lerp_angle(rotation, target_rotation, rotation_smooth_speed * delta)
	scale = scale.move_toward(target_scale, scale_smooth_speed * delta)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_scale *= (1.0 + scale_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_scale *= (1.0 - scale_step)

		target_scale.x = clamp(target_scale.x, min_scale, max_scale)
		target_scale.y = clamp(target_scale.y, min_scale, max_scale)
