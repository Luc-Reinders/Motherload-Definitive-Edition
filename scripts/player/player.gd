extends CharacterBody2D
class_name Player

const X_FRICTION = 400.0
const GRAVITY = 400.0

const MAX_X_ACCEL = 800.0
const MAX_Y_ACCEL = 800.0

const MAX_X_VELOCITY = 300.0
const MAX_Y_VELOCITY = 300.0

const MAX_DRILL_VELOCITY = 100.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var earth : Earth = get_parent().get_node("Earth")

var drilling = false
var drilling_target_cell: Vector2i
var drilling_target_global_pos: Vector2
var drilling_initial_diff: Vector2



func get_tile_below() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	# Cell is the player occupied cell, so look one cell below
	cell.y += 1
	return cell

func earth_has_tile(cell: Vector2i) -> bool:
	return earth.get_cell_source_id(cell) != -1

func start_drilling() -> void:
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 
	
	var cell = get_tile_below()
	
	if earth_has_tile(cell):
		drilling = true
		drilling_target_cell = cell
		
		# Map cell coordinates back to global coordinate
		drilling_target_global_pos = earth.to_global(earth.map_to_local(cell))
		
		# Initial difference before start of drilling. This is needed later
		# for horizontal alignment during drilling
		drilling_initial_diff = drilling_target_global_pos - global_position

func finish_drilling() -> void:
	# Re-enable collisions after player is done drilling
	collision_shape.disabled = false 
	
	drilling = false
	
	# Erase tile
	earth.set_cell(drilling_target_cell, -1)
	# Reset velocity
	velocity = Vector2.ZERO



func _physics_process(delta: float) -> void:
	
	# Drilling --------------------------------------------------------------
	if drilling:
		var diff_y = drilling_target_global_pos.y - global_position.y
		if diff_y > 0: # Player has not yet reached the target y
			velocity.y = MAX_DRILL_VELOCITY
			
			# Calculate drilling progress. Start is 0 and end is 1
			var init_diff_y = drilling_initial_diff.y
			var drilling_progress = (init_diff_y - diff_y) / init_diff_y
			
			# Set x position based on drilling progress
			var init_diff_x = drilling_initial_diff.x
			var target_pos_x = drilling_target_global_pos.x
			var init_start_x = target_pos_x - init_diff_x
			global_position.x = init_start_x + init_diff_x * drilling_progress
			
			# Set dug dirt texture when at least halfway through drilling
			if drilling_progress >= 0.5:
				pass # TODO: FIX WITH NEW LAYERING SCHEME
				#earth.set_tile(drilling_target_cell, Tiles.HALF_DUG)
			
		else: # Player is at least as deep as the target y
			finish_drilling()
	
	# Manual movement -------------------------------------------------------
	else:
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
func _process(delta: float):
	queue_redraw()
func _draw():
	if drilling:
		draw_circle(to_local(drilling_target_global_pos), 5.0, Color.RED)
