extends CharacterBody2D
class_name PlayerAbstract

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
@export var earth : EarthAbstract # TODO: Remove as export and make an argument in methods?

@export var pod_mass: int # Mass in Decakilograms (1980 kgs becomes 198)

# Pod component variables
var drill: Drill 
var hull: Hull
var engine: PodEngine
var fuel_tank: FuelTank
var radiator: Radiator
var bay: Bay

# Stats
var fuel: float
var health: float
var money: int
var bay_contents: Dictionary[Collectable, int] = {}
var items: Dictionary[Item, int] = {}

func calculate_weight() -> int:
	var w = pod_mass
	for collectable in bay_contents:
		w += bay_contents[collectable] * collectable.base_mass
	return w
func calculate_bay_space() -> int:
	var s = bay.base_size
	for collectable in bay_contents:
		s -= bay_contents[collectable]
	return s


# Drilling logic variables
var _drilling: bool = false
var _drilling_direction: DrillDirection
var _drilling_target_cell: Vector2i
var _drilling_target_global_pos: Vector2
# Drilling downwards logic variables
var _preparing_drilling_down: bool = false
var _drilling_initial_target_diff: Vector2



func is_drilling() -> bool:
	return _drilling

## Returns whether the player is facing right. DOES NOT WORK WITH TURNING!
func is_facing_right() -> bool:
	return animated_sprite.flip_h
func face_right() -> void:
	animated_sprite.flip_h = true
func face_left() -> void:
	animated_sprite.flip_h = false
func flip_face() -> void:
	animated_sprite.flip_h = !animated_sprite.flip_h


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
	
	if is_facing_right(): 
		cell.x += 1
	else: # Looking left
		cell.x -= 1
	
	return cell



func prepare_for_drilling_down() -> void:
	_preparing_drilling_down = true

func start_drilling(drill_direction: DrillDirection) -> void:
	# Set global player variables
	_drilling = true
	_drilling_direction = drill_direction
	
	var target_cell: Vector2i
	if drill_direction == DrillDirection.DOWN:
		target_cell = get_cell_below()
	elif drill_direction == DrillDirection.SIDE: 
		target_cell = get_cell_side()
	
	# Set global player variable
	_drilling_target_cell = target_cell
	_drilling_target_global_pos = earth.to_global(earth.map_to_local(target_cell))
	_drilling_initial_target_diff = _drilling_target_global_pos - global_position
	
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 
	
	# Setting global player variables specifically for drilling down
	if drill_direction == DrillDirection.DOWN:
		_preparing_drilling_down = false
		
		

func finish_drilling() -> void:
	# Re-enable collisions after player is done drilling
	collision_shape.disabled = false 
	
	_drilling = false
	
	# Erase tile and update cave textures
	earth.set_cell(_drilling_target_cell, -1)
	earth.set_appropriate_cave_textures_3x3(_drilling_target_cell)
	
	# Reset velocity
	velocity = Vector2.ZERO



func _physics_process(delta: float) -> void:
	
	# Drilling --------------------------------------------------------------
	if _drilling:
		# TODO: There is some duplicate code between the drilling down and sideways. Can't be
		# bothered to fix it now xd
		
		if _drilling_direction == DrillDirection.DOWN:
			var diff_y = _drilling_target_global_pos.y - global_position.y
			if diff_y > 0: # Player has not yet reached the target y
				velocity.y = MAX_DRILL_VELOCITY
			
				# Calculate drilling progress between 0 and 1
				var init_diff_y = _drilling_initial_target_diff.y
				var drilling_progress_y = (init_diff_y - diff_y) / init_diff_y
			
				# Set x position based on drilling progress
				var init_diff_x = _drilling_initial_target_diff.x
				var target_pos_x = _drilling_target_global_pos.x
				var init_start_x = target_pos_x - init_diff_x
				global_position.x = init_start_x + init_diff_x * drilling_progress_y
			
				# Set dug dirt texture when at least halfway through drilling
				if drilling_progress_y >= 0.5:
					earth.set_half_dug(_drilling_target_cell, _drilling_direction, is_facing_right())
			else: # Player is at least as deep as the target y
				finish_drilling()
		elif _drilling_direction == DrillDirection.SIDE:
			var diff_x: float
			if is_facing_right(): # Drilling right
				diff_x = _drilling_target_global_pos.x - global_position.x
			else: # Drilling to the left
				diff_x = global_position.x - _drilling_target_global_pos.x
			
			if diff_x > 0:
				if is_facing_right(): # Facing right
					velocity.x = MAX_DRILL_VELOCITY
				else: # Facing left
					velocity.x = -MAX_DRILL_VELOCITY
				
				# Calculate drilling progress between 0 and 1
				var init_diff_x = abs(_drilling_initial_target_diff.x)
				var drilling_progress_x = (init_diff_x - diff_x) / init_diff_x
				
				# Set dug dirt texture when at least halfway through drilling
				if drilling_progress_x >= 0.5:
					earth.set_half_dug(_drilling_target_cell, _drilling_direction, is_facing_right())
			else:
				finish_drilling() 
	
	# Manual movement -------------------------------------------------------
	elif not _preparing_drilling_down:
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
	if _drilling:
		draw_circle(to_local(_drilling_target_global_pos), 5.0, Color.RED)
