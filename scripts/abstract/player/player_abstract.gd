extends CharacterBody2D
class_name PlayerAbstract

enum DigDirection {
	SIDE,
	DOWN
}

# Nodes in the player class
@export var animated_sprite : AnimatedSprite2D
@export var collision_shape : CollisionShape2D
@export var state_machine: StateMachine
# Not in player class itself, but very useful for helper functions
@export var earth : EarthAbstract 

# Pod mass and component variables
@export var pod_mass: int
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

# Other variables
var steam_rate: float = 0.0 # Represents rate of steam particles that need to be emitted
var rotor_speed: float = 0 # Used in the animation speed of the flying animation

# digging logic variables
var _digging: bool = false
func is_digging() -> bool:
	return _digging
var _digging_direction: DigDirection
var _digging_velocity: float
var _digging_init_global_pos: Vector2
var _digging_reload_flag: bool = false # For loading half dug tile, damaging player, and gas pockets
var _digging_target_cell: Vector2i
var _digging_x_align_velocity: float # aligning horizontally velocity for digging down

# Turning logic variable
var _turning: bool = false
func is_turning() -> bool:
	return _turning



func is_facing_right() -> bool:
	return animated_sprite.flip_h
func face_right() -> void:
	animated_sprite.flip_h = true
func face_left() -> void:
	animated_sprite.flip_h = false
func flip_face() -> void:
	animated_sprite.flip_h = !animated_sprite.flip_h

## Gets the cell below the player
func get_cell_below() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	# Cell is the player occupied cell, so look one cell below
	cell.y += 1
	return cell
## Gets the cell next to where the player is looking
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





func calculate_weight() -> int:
	push_error("calculate_weight() must be overridden!")
	return -1
func calculate_bay_space() -> int:
	push_error("calculate_bay_space() must be overridden!")
	return -1
func get_depth() -> float:
	push_error("calculate_bay_space() must be overridden!")
	return -1










## This method sets logic- and physics variables pre-digging appropriately.
func start_digging(drill_direction: DigDirection) -> void:
	# Set target cell
	if drill_direction == DigDirection.DOWN:
		_digging_target_cell = get_cell_below()
	elif drill_direction == DigDirection.SIDE: 
		_digging_target_cell = get_cell_side()
	
	# Set logic variables
	_digging = true
	_digging_direction = drill_direction
	_digging_init_global_pos = global_position
	_digging_reload_flag = false
	
	# Calculate the digging velocity. First we calculate the actionscript velocity by mimicking the
	# actionscript code. Then convert the actionscript velocity over to godot's velocity.
	var digVel := calculate_dig_velocity_actionscript(get_depth(), drill.base_drill_speed)
	_digging_velocity = digVel * Constants.FLASH_FPS
	
	if drill_direction == DigDirection.DOWN:
		# Here we set the horizontal align velocity when digging down. For the formula we require
		# the difference between the player and the center of the tile in pixels. The formula to
		# calculate the velocity is based on the Motherload code
		var digging_target_global_pos := earth.to_global(earth.map_to_local(_digging_target_cell))
		var player_to_target_diff := digging_target_global_pos - global_position
		var xAlignVel := (float(player_to_target_diff.x) / 50.0) * digVel
		_digging_x_align_velocity = xAlignVel * Constants.FLASH_FPS
		
		velocity.y = _digging_velocity
		velocity.x = _digging_x_align_velocity
	else: # Digging sideways
		if is_facing_right():
			velocity.x = _digging_velocity
		else: # facing left
			velocity.x = -_digging_velocity
	
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 

## This method sets logic- and physics variables post-digging appropriately. It also updates the
## earth tiles with appropriate textures.
func finish_digging() -> void:
	_digging = false
	
	# Re-enable collisions after player is done digging
	collision_shape.disabled = false 
	
	# Erase tile and update cave textures
	earth.set_cell(_digging_target_cell, -1)
	earth.set_appropriate_cave_textures_3x3(_digging_target_cell)
	
	# Reset velocity
	velocity = Vector2.ZERO

## Calculate the actionscript digging velocity from the depth and drill speed
func calculate_dig_velocity_actionscript(depth: float, drill_base_speed: float) -> float:
	return (0.5 * drill_base_speed) / (1.0 - (depth / 1000.0))










func _physics_process(delta: float) -> void:
	# Flash Motherload has frame-dependent physics calculations. We assume that our game runs at
	# the optimal flash fps (24) and adjust our delta time for it. This allows us to keep the
	# formulas in the decompiled code precisely the same, but still adjust for delta time.
	var delta_f: float = delta * Constants.FLASH_FPS
	
	if is_digging():
		_physics_process_digging(delta, delta_f)
	else:
		_physics_process_move(delta, delta_f)



## In this method we process the digging as closely as possible to the original flash Motherload.
## The most notable exception in design of the code is the use of delta time. 
func _physics_process_digging(_delta: float, delta_f: float) -> void:
	steam_rate += 4 * delta_f
	fuel -= (engine.base_power / 25000.0) * delta_f
	
	if _digging_direction == DigDirection.DOWN:
		var yMoved := global_position.y - _digging_init_global_pos.y
		var tile := earth.get_tile(get_cell_below())
		
		if yMoved < 50.0:
			if yMoved > 20.0 and not _digging_reload_flag:
				_digging_reload_flag = true
				
				earth.set_half_dug(_digging_target_cell, _digging_direction, is_facing_right())
				if Tiles.is_lava_tile(tile):
					pass # TODO: do damage
				# TODO: add detection for natural gas tile
		else:
			finish_digging()
	else: # Digging sideways
		var xMoved := global_position.x - _digging_init_global_pos.x
		var tile := earth.get_tile(get_cell_side())
		
		if abs(xMoved) < 40.0:
			if abs(xMoved) > 15.0 and not _digging_reload_flag:
				_digging_reload_flag = true
				
				earth.set_half_dug(_digging_target_cell, _digging_direction, is_facing_right())
				if Tiles.is_lava_tile(tile):
					pass # TODO: do damage
				# TODO: add detection for natural gas tile
		else:
			finish_digging()
	
	move_and_slide()



## In this method we process the movement as closely as possible to the original flash Motherload.
## The most notable exception in design of the code is the use of delta time. 
func _physics_process_move(_delta: float, delta_f: float) -> void:
	var r: bool = Input.is_action_pressed("move_right")
	var l: bool = Input.is_action_pressed("move_left")
	var u: bool = Input.is_action_pressed("move_up")
	
	# The velocity in Godot has unit px/sec and in the flash Motherload script it has unit px/frame.
	# To resolve this, we convert our x velocity to a representative velocity in the ActionScript
	# code. Then we run it through (which is essentially) the ActionScript code, and convert the
	# ActionScript representative velocity back into Godot's velocity system. 
	var xVel: float = float(velocity.x) / float(Constants.FLASH_FPS)
	var yVel: float = float(velocity.y) / float(Constants.FLASH_FPS)
	var updatedVel = actionscript_move_subroutine(xVel, yVel, delta_f, r, l, u)
	velocity.x = updatedVel.x * Constants.FLASH_FPS
	velocity.y = updatedVel.y * Constants.FLASH_FPS
	
	# Move now so I can check for bouncing afterwards
	var on_floor_before_move = is_on_floor()
	var on_ceiling_before_move = is_on_ceiling()
	move_and_slide() 
	
	# Compute bouncing variables for next iteration. Note that yVel is the ActionScript velocity
	# of the *previous* iteration. However, since yVel is the ActionScript velocity in the previous
	# iteration, we use it directly to calculate the new Godot y velocity.
	if not on_floor_before_move and is_on_floor(): # Player hit the ground on this frame
		if yVel > 7:
			var damage = yVel / 7.0
			# TODO: apply damage
		velocity.y = -0.2 * (yVel * Constants.FLASH_FPS)
	elif not on_ceiling_before_move and is_on_ceiling(): #Player hit the ceiling on this frame
		velocity.y = -0.2 * (yVel * Constants.FLASH_FPS)



func actionscript_move_subroutine(xVel: float, yVel: float, delta_f: float, r: bool, l: bool, u: bool) -> Vector2:
	# Check whether pod is not moving vertically and is on floor (grounded?)
	if int(yVel / 10.0) == 0 and is_on_floor():
		if r:
			xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight())) * delta_f, engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_rate += 4 * delta_f
		elif l:
			xVel = maxf(xVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_rate += 4 * delta_f
		elif u and not is_turning(): # on floor and turning means pod can't take off
			yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * 2 * delta_f, -engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			
		# Apply friction using delta time
		xVel -= xVel * (1 - Constants.GROUND_FRICTION) * delta_f
			
		# Set rotation to 0 degrees and rotor speed to 0 since we are on the ground
		self.rotation_degrees = 0
		rotor_speed = 0
		
	else: # Airborn case I guess? 
		if r:
			xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, engine.base_power / 10.0)
			rotation_degrees = minf(rotation_degrees + (engine.base_power / 50.0) * delta_f, 15)
			fuel -= (engine.base_power / 50000.0) * delta_f
			rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
			steam_rate += 2 * delta_f
		elif l:
			xVel = maxf(xVel - (float(engine.base_power)/float(calculate_weight())/1.5)*delta_f, -engine.base_power / 10.0)
			rotation_degrees = maxf(rotation_degrees - (engine.base_power / 50.0) * delta_f, -15)
			fuel -= (engine.base_power / 50000.0) * delta_f
			rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
			steam_rate += 2 * delta_f
		# Flying with no direction held, so we decrease angle of flight towards zero
		elif rotation_degrees > 1:
			rotation_degrees -= 1 * delta_f
		elif rotation_degrees < -1:
			rotation_degrees += 1 * delta_f
			
		if u:
			## My best guess for this case distinction is when the pod is taking off, we do not
			## need to update the rotor speed. Also physics slightly different I guess.
			if state_machine.is_current_any(["Flight","TurnFlight"]):
				rotor_speed = minf(rotor_speed + 1 * delta_f, 11)
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 12.0)
			else:
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, -engine.base_power / 12.0)
			rotation_degrees *= 0.7 # Random rotation resistance? Why?
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_rate += 4 * delta_f
			
		# Add air resistance and gravity
		xVel -= xVel * (1 - Constants.AIR_RESISTANCE) * delta_f
		yVel -= yVel * (1 - Constants.AIR_RESISTANCE) * delta_f
		yVel = minf(yVel + (Constants.GRAVITY / 30.0) * delta_f, 20.0)
			
		# The code applies this if the mode is "air", so I assume this means both flight and 
		# turning whilst flying. 
		if state_machine.is_current_any(["Flight","TurnFlight"]):
			rotor_speed = maxf(rotor_speed - rotor_speed * 0.05 * delta_f, 2)
	
	fuel -= (engine.base_power / 100000.0) * delta_f # Base fuel use?
	
	return Vector2(xVel, yVel)
