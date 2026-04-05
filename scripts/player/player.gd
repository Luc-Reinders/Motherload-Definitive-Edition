extends CharacterBody2D
class_name Player

# TODO: Create is_facing_left and ..._right method as to clearify flip_h logic.

enum DrillDirection {
	SIDE,
	DOWN
}

const X_FRICTION = 400.0
const GRAVITY = 400.0

const MAX_X_ACCEL = 800.0
const MAX_Y_ACCEL = 800.0

const MAX_X_VELOCITY = 300.0
const MAX_Y_VELOCITY = 300.0

const MAX_DRILL_VELOCITY = 50.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var earth : Earth = get_parent().get_node("Earth")

# Drilling variables
var drilling: bool = false
var drilling_direction: DrillDirection
var drilling_target_cell: Vector2i
var drilling_target_global_pos: Vector2

# Drilling down variables
var preparing_drilling_down: bool = false
var drilling_initial_target_diff: Vector2


# TODO: collaps get_cell methods into one general method?
func get_cell_below() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	# Cell is the player occupied cell, so look one cell below
	cell.y += 1
	return cell

## Gets the cell next to where the pod is looking
func get_cell_side() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	if animated_sprite.flip_h: # Looking right
		cell.x += 1
	else: # Looking left
		cell.x -= 1
	
	return cell



func prepare_for_drilling_down() -> void:
	preparing_drilling_down = true

func start_drilling(drill_direction: DrillDirection) -> void:
	# Set global player variables
	drilling = true
	drilling_direction = drill_direction
	
	var target_cell: Vector2i
	if drill_direction == DrillDirection.DOWN:
		target_cell = get_cell_below()
	elif drill_direction == DrillDirection.SIDE: 
		target_cell = get_cell_side()
	
	# Set global player variable
	drilling_target_cell = target_cell
	drilling_target_global_pos = earth.to_global(earth.map_to_local(target_cell))
	drilling_initial_target_diff = drilling_target_global_pos - global_position
	
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 
	
	# Setting global player variables specifically for drilling down
	if drill_direction == DrillDirection.DOWN:
		preparing_drilling_down = false
		
		

func finish_drilling() -> void:
	# Re-enable collisions after player is done drilling
	collision_shape.disabled = false 
	
	drilling = false
	
	# Erase tile and update cave textures
	earth.set_cell(drilling_target_cell, -1)
	earth.set_appropriate_cave_textures_3x3(drilling_target_cell)
	
	# Reset velocity
	velocity = Vector2.ZERO



func _physics_process(delta: float) -> void:
	
	# Drilling --------------------------------------------------------------
	if drilling:
		# TODO: There is some duplicate code between the drilling down and sideways. Can't be
		# bothered to fix it now xd
		
		if drilling_direction == DrillDirection.DOWN:
			var diff_y = drilling_target_global_pos.y - global_position.y
			if diff_y > 0: # Player has not yet reached the target y
				velocity.y = MAX_DRILL_VELOCITY
			
				# Calculate drilling progress between 0 and 1
				var init_diff_y = drilling_initial_target_diff.y
				var drilling_progress_y = (init_diff_y - diff_y) / init_diff_y
			
				# Set x position based on drilling progress
				var init_diff_x = drilling_initial_target_diff.x
				var target_pos_x = drilling_target_global_pos.x
				var init_start_x = target_pos_x - init_diff_x
				global_position.x = init_start_x + init_diff_x * drilling_progress_y
			
				# Set dug dirt texture when at least halfway through drilling
				if drilling_progress_y >= 0.5:
					earth.set_half_dug(drilling_target_cell, drilling_direction, animated_sprite.flip_h)
			else: # Player is at least as deep as the target y
				finish_drilling()
		elif drilling_direction == DrillDirection.SIDE:
			var diff_x: float
			if animated_sprite.flip_h: # Drilling right
				diff_x = drilling_target_global_pos.x - global_position.x
			else: # Drilling to the left
				diff_x = global_position.x - drilling_target_global_pos.x
			
			if diff_x > 0:
				if animated_sprite.flip_h: # Facing right
					velocity.x = MAX_DRILL_VELOCITY
				else: # Facing left
					velocity.x = -MAX_DRILL_VELOCITY
				
				# Calculate drilling progress between 0 and 1
				var init_diff_x = abs(drilling_initial_target_diff.x)
				var drilling_progress_x = (init_diff_x - diff_x) / init_diff_x
				
				# Set dug dirt texture when at least halfway through drilling
				if drilling_progress_x >= 0.5:
					earth.set_half_dug(drilling_target_cell, drilling_direction, animated_sprite.flip_h)
			else:
				finish_drilling() 
	
	# Manual movement -------------------------------------------------------
	elif not preparing_drilling_down:
		# Vertical Movement ----------------------------------
		if Input.is_action_pressed("move_up"):
			velocity.y += (GRAVITY - MAX_Y_ACCEL) * delta
		elif not is_on_floor():
			velocity.y += GRAVITY * delta

		# Horizontal Movement --------------------------------
	
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


# Drilling debugging
@warning_ignore("unused_parameter")
func _process(delta: float):
	queue_redraw()
func _draw():
	if drilling:
		draw_circle(to_local(drilling_target_global_pos), 5.0, Color.RED)
