extends CharacterBody2D


const MAX_X_VELOCITY = 300.0
const MAX_Y_VELOCITY = 400.0
const GRAVITY = 1200.0

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	
	# Vertical Movement --------------------------------------------------------------
	if Input.is_action_pressed("move_up"):
		velocity.y = -MAX_Y_VELOCITY
	elif not is_on_floor():
		velocity.y += GRAVITY * delta

	# Horizontal Movement ------------------------------------------------------------
	
	# Get the input direction: -1 = left, 0 = neutral, 1 = right
	var direction := Input.get_axis("move_left", "move_right")
	
	# Turning
	if direction < 0 and animated_sprite.flip_h == true and is_on_floor():
		animated_sprite.play("turn_ground")
		
	
	# flip sprite depending on rotation
	if direction > 0:
		animated_sprite.flip_h = true # Right
	elif direction < 0:
		animated_sprite.flip_h = false # Left
	
	if direction:
		velocity.x = direction * MAX_X_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, MAX_X_VELOCITY)

	move_and_slide()
