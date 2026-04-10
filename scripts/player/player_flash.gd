extends PlayerAbstract
class_name PlayerFlash

const FLASH_FPS = 24 # Flash runs on 24 fps

const MAX_DRILL_VELOCITY = 50.0




const GRAVITY: float = 9.81
const FRICTION: float = 0.94
const AIR_RESISTANCE: float = 0.98



## In this method we process the movement as closely as possible to the original flash Motherload.
## The only exception to exact equality of the code in ActionScript is the delta time paradism, 
## which Motherload does not use. 
func _physics_process(delta: float) -> void:
	var right_pressed: bool = Input.is_action_pressed("move_right")
	var left_pressed: bool = Input.is_action_pressed("move_left")
	var up_pressed: bool = Input.is_action_pressed("move_up")

	# Flash Motherload has frame-dependent physics calculations. We assume that our game runs at
	# the optimal flash fps (24) and adjust our delta time for it. This allows us to keep the
	# formulas in the decompiled code precisely the same, but still adjust for delta time.
	var delta_f: float = delta * FLASH_FPS
	
	# The velocity in Godot has unit px/sec and in the flash Motherload script it has unit px/frame.
	# To resolve this, we convert our x velocity to a representative velocity in the ActionScript
	# code. Then we run it through (which is essentially) the ActionScript code, and convert the
	# ActionScript representative velocity back into Godot's velocity system. 
	var xVel: float = float(velocity.x) / float(FLASH_FPS)
	var yVel: float = float(velocity.y) / float(FLASH_FPS)
	
	# This handles movement outside of drilling. 
	if !is_drilling():
		# Check whether pod is not moving vertically and is on floor (grounded?)
		if int(yVel / 10.0) == 0 and is_on_floor():
			if right_pressed:
				xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight())) * delta_f, engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
				steam_count += 4
			elif left_pressed:
				xVel = maxf(xVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
				steam_count += 4
			elif up_pressed and not is_turning(): # on floor and turning means pod can't take off
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * 2 * delta_f, -engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
			
			# Apply friction using delta time
			xVel -= xVel * (1 - FRICTION) * delta_f
			
			# Set rotation to 0 degrees and rotor speed to 0 since we are on the ground
			self.rotation_degrees = 0
			rotor_speed = 0
		
		else: # Airborn case I guess? 
			if right_pressed:
				xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, engine.base_power / 10.0)
				rotation_degrees = minf(rotation_degrees + (engine.base_power / 50.0) * delta_f, 15)
				fuel -= (engine.base_power / 50000.0) * delta_f
				rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
				steam_count += 2
			elif left_pressed:
				xVel = maxf(xVel - (float(engine.base_power)/float(calculate_weight())/1.5)*delta_f, -engine.base_power / 10.0)
				rotation_degrees = maxf(rotation_degrees - (engine.base_power / 50.0) * delta_f, -15)
				fuel -= (engine.base_power / 50000.0) * delta_f
				rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
				steam_count += 2
			# Flying with no direction held, so we decrease angle of flight towards zero
			elif rotation_degrees > 1:
				rotation_degrees -= 1 * delta_f
			elif rotation_degrees < -1:
				rotation_degrees += 1 * delta_f
			
			if up_pressed:
				## My best guess for this case distinction is when the pod is taking off, we do not
				## need to update the rotor speed. Also physics slightly different I guess.
				if state_machine.is_current_any(["Flight","TurnFlight"]):
					rotor_speed = minf(rotor_speed + 1 * delta_f, 11)
					yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 12.0)
				else:
					yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, -engine.base_power / 12.0)
				rotation_degrees *= 0.7 # Random rotation resistance? Why?
				fuel -= (engine.base_power / 50000.0) * delta_f
				steam_count += 4
			
			# Add air resistance and gravity
			xVel -= xVel * (1 - AIR_RESISTANCE) * delta_f
			yVel -= yVel * (1 - AIR_RESISTANCE) * delta_f
			yVel = minf(yVel + (GRAVITY / 30.0) * delta_f, 20.0)
			
			# The code applies this if the mode is "air", so I assume this means both flight and 
			# turning whilst flying. 
			if state_machine.is_current_any(["Flight","TurnFlight"]):
				rotor_speed = maxf(rotor_speed * 0.95, 2)
	
	fuel -= (engine.base_power / 100000.0) * delta_f # Base fuel use?
	
	print(yVel)
	
	# Calculate ActionScripts velocities back into Godot's velocity system
	velocity.x = xVel * FLASH_FPS
	velocity.y = yVel * FLASH_FPS
	
	# Move now so I can check for bouncing afterwards
	var was_on_floor = is_on_floor()
	var was_on_ceiling = is_on_ceiling()
	move_and_slide() 
	
	# Compute bouncing variables for next iteration. Note that yVel is the ActionScript velocity
	# of the *previous* iteration. However, since yVel is the ActionScript velocity in the previous
	# iteration, we use it directly to calculate the new Godot y velocity.
	if not was_on_floor and is_on_floor(): # Player hit the ground on this frame
		if yVel > 7:
			var damage = yVel / 7.0
			# TODO: apply damage
		velocity.y = -0.2 * (yVel * FLASH_FPS)
	elif not was_on_ceiling and is_on_ceiling(): #Player hit the ceiling on this frame
		velocity.y = -0.2 * (yVel * FLASH_FPS)
	

	"""
	
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
	"""
