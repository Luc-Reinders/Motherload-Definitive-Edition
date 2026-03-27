extends CharacterBody2D

const X_FRICTION = 400.0
const GRAVITY = 400.0

const MAX_X_ACCEL = 800.0
const MAX_Y_ACCEL = 800.0

const MAX_X_VELOCITY = 300.0
const MAX_Y_VELOCITY = 300.0

@onready var animated_sprite = $AnimatedSprite


func _physics_process(delta: float) -> void:
	
	# Vertical Movement --------------------------------------------------------------
	if Input.is_action_pressed("move_up"):
		velocity.y += (GRAVITY - MAX_Y_ACCEL) * delta
	elif not is_on_floor():
		velocity.y += GRAVITY * delta



	# Horizontal Movement ------------------------------------------------------------
	
	# Get the input direction: -1 = left, 0 = neutral, 1 = right
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x += (MAX_X_ACCEL - X_FRICTION) * direction * delta
	else:
		velocity.x = move_toward(velocity.x, 0, X_FRICTION * delta)

	# clamp velocities
	velocity.y = clamp(velocity.y, -MAX_Y_VELOCITY, MAX_Y_VELOCITY)
	velocity.x = clamp(velocity.x, -MAX_X_VELOCITY, MAX_X_VELOCITY)
	
	move_and_slide()
