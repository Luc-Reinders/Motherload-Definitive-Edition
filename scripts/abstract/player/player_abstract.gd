extends CharacterBody2D
class_name PlayerAbstract

enum DigDirection {
	SIDE,
	DOWN
}
enum DigCheckResult {
	VALID,
	HARD,
	INVALID
}

# Nodes that must be present in the player scene
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
var steam_count: float = 0.0 # Counter variable for emitting steam puffs out of the exhaust
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

# collision logic variables
var _was_on_floor_previous_physics_iter: bool = false
var _was_on_ceiling_previous_physics_iter: bool = false
var _yVel_previous_physics_iter: float = 0

# Turning logic variable
var _turning: bool = false
func is_turning() -> bool:
	return _turning
func start_turning() -> void:
	_turning = true
func finish_turning() -> void:
	_turning = false
	

@export var puff_scene = preload("res://scenes/steam_particle.tscn") # no better way?


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



## Checks whether the neighboring tile in the digging direction is a diggable-, hard- or undiggable
## tile. 
func dig_check(dig_direction: DigDirection) -> DigCheckResult:
	var cell: Vector2i
	if dig_direction == DigDirection.DOWN:
		cell = get_cell_below()
	else:
		cell = get_cell_side()
	var tile: Vector2i = earth.get_tile(cell)
	
	if Tiles.is_diggable_tile(tile):
		return DigCheckResult.VALID
	elif Tiles.is_hard_tile(tile):
		return DigCheckResult.HARD
	else:
		return DigCheckResult.INVALID



## Motherload has frame-dependent physics calculations. This means that the velocities used in the 
## AS code have unit px/frame. The velocities in Godot have unit px/s. To make conversions between 
## Godot's- and AS's velocities, we must fix an FPS value for Flash Motherload. Once we do that, 
## we can easily convert between the velocities like this:
## VelAS = velocity_godot / FLASH_FPS
## velocity_godot = VelAS * FLASH_FPS
static func convert_to_AS_velocity(godot_velocity: float) -> float:
	return godot_velocity / Constants.FLASH_FPS 
static func convert_to_godot_velocity(ASVel: float) -> float:
	return ASVel * Constants.FLASH_FPS



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
	_digging_velocity = convert_to_godot_velocity(digVel)
	
	if drill_direction == DigDirection.DOWN:
		# Here we set the horizontal align velocity when digging down. For the formula we require
		# the difference between the player and the center of the tile in pixels. The formula to
		# calculate the velocity is based on the Motherload code
		var digging_target_global_pos := earth.to_global(earth.map_to_local(_digging_target_cell))
		var player_to_target_diff := digging_target_global_pos - global_position
		var xAlignVel := (float(player_to_target_diff.x) / 50.0) * digVel
		_digging_x_align_velocity = convert_to_godot_velocity(xAlignVel)
		
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










## This comment is used to explain the main paradigms used to recreate the Motherload physics as
## closely as possible. We will often refer to the code of Motherload as ActionScript (AS) code, 
## since AS is the main programming language used for Motherload.
##
## First, Motherload has frame-dependent physics calculations. This means that the velocities used
## in the AS code have unit px/frame. The velocities in Godot have unit px/s. We can make a 
## conversion between these velocities by fixing a value for the FPS in Flash Motherload. See the 
## [method convert_to_AS_velocity] and [method convert_to_godot_velocity] for more details.
## These velocity conversions give us a strategy to re-create the game physics as closely as we 
## possibly can:
## 1. Convert Godot velocity to AS velocity
## 2. Run physic process subroutines acting as closely(*) as possible to the original flash code. 
##    These subroutines may update the AS velocities passed in. 
## 3. Convert AS velocity back into Godot velocity
##
## (*): Whilst we aim to re-create the subroutines as closely as possible, we do want the subroutine
## physics to use the delta-time paradigm for obvious reasons. A very elegant solution can be 
## obtained that minimizes the amount of calculation changes needed whilst still keeping the
## physics practically identical:
## We already assume a fixed FPS that Motherload runs on. If our physics loop updates exactly every
## 1/FPS_FLASH seconds, then all the formulas remain the same. However, if our physics updates every
## 1/(2 * FPS_FLASH) seconds (so twice as fast as Flash Motherload), then we want to halve all
## incremental calculations. This is the core idea behind delta-time, but our delta in this case
## is linearly scaled. To be precise, all incremental calculations need to be scaled by a factor of
## delta * FLASH_FPS. This aligns with the previous examples as well.
## Thus we calculate delta_f = delta * FLASH_FPS, which we use to modify our incremental
## calculations in our AS subroutines. 
func _physics_process(delta: float) -> void:
	var delta_f: float = delta * Constants.FLASH_FPS
	
	# Godot velocity -> AS velocity conversion
	var xVel := convert_to_AS_velocity(velocity.x)
	var yVel := convert_to_AS_velocity(velocity.y)
	
	# Run AS subroutine
	var Vel := _physics_as_subroutine(xVel, yVel, delta_f)
	
	# AS velocity -> Godot velocity conversion and apply the velocity
	velocity.x = convert_to_godot_velocity(Vel.x)
	velocity.y = convert_to_godot_velocity(Vel.y)
	
	move_and_slide() 





func _physics_as_subroutine(xVel: float, yVel: float, delta_f: float) -> Vector2:
	# Digging and player movement subroutines
	if is_digging():
		_process_digging_as_subroutine(delta_f)
	else:
		var Vel : Vector2 = _process_moving_as_subroutine(xVel, yVel, delta_f)
		xVel = Vel.x
		yVel = Vel.y
	
	# Base fuel use
	fuel -= (engine.base_power / 100000.0) * delta_f 
	
	# The next code is on the handling of player bouncing; If you hit the ground (or ceiling) hard, 
	# you bounce a couple of times before becoming fully grounded. However, the way we implement it 
	# here is functionally slightly different from the AS code. The difference is the use of the 
	# previous yVel velocity instead of yVel directly. The best way to explain how and why, is to 
	# explain how Motherload handles the player bouncing:
	# Motherload checks whether the player would hit the ground on the next frame with the given
	# y velocity. If the player would hit the ground, then we apply the "bounce" immediately, 
	# meaning we reverse the velocity times factor 0.2. However, since the player is still in the
	# air, this would mean the player practically ends up bouncing on air.
	# This strange physics behavior is hardly noticable in game, mostly due to the camera lagging
	# behind the player when falling with high velocity. However, recreating this behavior could 
	# lead to strange behavior with the delta-time paradigm in cases of extremely low FPS; If the 
	# FPS is very low, the velocities are scaled to still match the game physics. This would mean 
	# the downwards velocity is also scaled up, causing this "air-bouncing" problem to be amplified.
	# 
	# This behavior is obviously not desired. So instead, we let the player first move to the 
	# ground (Godot handles this nicely for us). Then we apply the bounce velocity using the 
	# previous yVel value. Think of it as delaying the AS bounce for 1 frame to let the player 
	# properly hit the ground. 
	# TODO: Perhaps add in tiny factor to make bounce a little higher. On average, the bounce would
	# be higher in Flash Motherload due to this "air-bouncing" behavior then is currently 
	# implemented here.
	if _yVel_previous_physics_iter > 0:
		if is_on_floor(): 
			if not _was_on_floor_previous_physics_iter:
				if _yVel_previous_physics_iter > 7.0:
					var damage = _yVel_previous_physics_iter / 2.0
					# TODO: apply damage
				yVel = -0.2 * _yVel_previous_physics_iter
			_was_on_floor_previous_physics_iter = true
		else:
			_was_on_floor_previous_physics_iter = false
	elif _yVel_previous_physics_iter < 0:
		if is_on_ceiling():
			if not _was_on_ceiling_previous_physics_iter:
				yVel = -0.2 * _yVel_previous_physics_iter 
			_was_on_ceiling_previous_physics_iter = true
		else:
			_was_on_ceiling_previous_physics_iter = false
	
	# Increased y-deadzone if on ground to prevent flying away when player is too fat :p
	# Note: This can be circumvented by dropping off of a tile and then initiating flight. 
	# TODO: Fix for recoded?
	if is_on_floor() and abs(yVel) < 0.12:
		yVel = 0.0
	
	# Deadzones for AS velocities
	if abs(xVel) < 0.12:
		xVel = 0.0
	if abs(yVel) < 0.07:
		yVel = 0.0
	
	# Passive steam count increase and spawn steam puffs
	steam_count += 2 * delta_f
	if steam_count > 20.0:
		steam_count = 0
		spawn_steam_puff()
	
	# Save current y velocity as previous iteration for next iteration
	_yVel_previous_physics_iter = yVel
	
	return Vector2(xVel, yVel)





## In this method we process the digging as closely as possible to the original flash Motherload.
## The most notable exception in design of the code is the use of delta time. 
func _process_digging_as_subroutine(delta_f: float) -> void:
	steam_count += 4 * delta_f
	fuel -= (engine.base_power / 25000.0) * delta_f
	
	if _digging_direction == DigDirection.DOWN:
		var yMoved := global_position.y - _digging_init_global_pos.y
		var tile := earth.get_tile(get_cell_below())
		
		if yMoved < 40.0: #50.0
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





## In this method we process the movement as closely as possible to the original flash Motherload.
## The most notable exception in design of the code is the use of delta time. 
func _process_moving_as_subroutine(xVel: float, yVel: float, delta_f: float) -> Vector2:
	var r: bool = Input.is_action_pressed("move_right")
	var l: bool = Input.is_action_pressed("move_left")
	var u: bool = Input.is_action_pressed("move_up")
	
	# Check whether pod is not moving vertically and is on floor (grounded?)
	if int(yVel / 10.0) == 0 and is_on_floor():
		if r:
			xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight())) * delta_f, engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_count += 4 * delta_f
		elif l:
			xVel = maxf(xVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_count += 4 * delta_f
		elif u and not is_turning(): # on floor and turning means pod can't take off
			yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * 2 * delta_f, -engine.base_power / 10.0)
			fuel -= (engine.base_power / 50000.0) * delta_f
			
		# Apply friction using delta time
		xVel -= xVel * (1 - Constants.GROUND_FRICTION) * delta_f
			
		# Set rotation to 0 degrees and rotor speed to 0 since we are on the ground
		animated_sprite.rotation_degrees = 0
		rotor_speed = 0
		
	else: # Airborn case I guess? 
		if r:
			xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, engine.base_power / 10.0)
			animated_sprite.rotation_degrees = minf(animated_sprite.rotation_degrees + (engine.base_power / 50.0) * delta_f, 15)
			fuel -= (engine.base_power / 50000.0) * delta_f
			rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
			steam_count += 2 * delta_f
		elif l:
			xVel = maxf(xVel - (float(engine.base_power)/float(calculate_weight())/1.5)*delta_f, -engine.base_power / 10.0)
			animated_sprite.rotation_degrees = maxf(animated_sprite.rotation_degrees - (engine.base_power / 50.0) * delta_f, -15)
			fuel -= (engine.base_power / 50000.0) * delta_f
			rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
			steam_count += 2 * delta_f
		# Flying with no direction held, so we decrease angle of flight towards zero
		elif animated_sprite.rotation_degrees > 1:
			animated_sprite.rotation_degrees -= 1 * delta_f
		elif animated_sprite.rotation_degrees < -1:
			animated_sprite.rotation_degrees += 1 * delta_f
			
		if u:
			## My best guess for this case distinction is when the pod is taking off, we do not
			## need to update the rotor speed. Also physics slightly different I guess.
			if state_machine.is_current_any(["Flight","TurnFlight"]):
				rotor_speed = minf(rotor_speed + 1 * delta_f, 11)
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 12.0)
			else:
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, -engine.base_power / 12.0)
			animated_sprite.rotation_degrees *= 0.7 # Random rotation resistance? Why?
			fuel -= (engine.base_power / 50000.0) * delta_f
			steam_count += 4 * delta_f
			
		# Add air resistance and gravity
		xVel -= xVel * (1 - Constants.AIR_RESISTANCE) * delta_f
		yVel -= yVel * (1 - Constants.AIR_RESISTANCE) * delta_f
		yVel = minf(yVel + (Constants.GRAVITY / 30.0) * delta_f, 20.0)
			
		# The code applies this if the mode is "air", so I assume this means both flight and 
		# turning whilst flying. 
		if state_machine.is_current_any(["Flight","TurnFlight"]):
			rotor_speed = maxf(rotor_speed - rotor_speed * 0.05 * delta_f, 2)
	
	return Vector2(xVel, yVel)





func spawn_steam_puff() -> void:
	# We add the puff to the scene tree first, so all nodes of the steam particle are loaded into
	# the scene tree.
	var puff: SteamParticle = puff_scene.instantiate()
	get_tree().current_scene.add_child(puff)
	
	var offset: int
	if is_facing_right():
		offset = -24
	else:
		offset = 24
		puff.animated_sprite.flip_h = true
	
	# Setting position and adding some randomness like in the Motherload code
	puff.global_position.x = global_position.x + offset + randi_range(0, 1) * 3 
	puff.global_position.y = global_position.y - 23
	puff.pivot.rotation_degrees = randi_range(0, 39) - 20
