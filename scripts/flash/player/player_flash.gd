extends PlayerAbstract
class_name PlayerFlash

const MAX_DRILL_VELOCITY = 50.0

const GRAVITY: float = 9.81
const FRICTION: float = 0.94
const AIR_RESISTANCE: float = 0.98



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

## Gets depth in feet (12.5 feet per block <=> 1 feet per 4 pixels)
func get_depth() -> float:
	return -(global_position.y + 17.0) / 4.0 # TODO: offset of +17 will have to change once changing player hitbox








func _physics_process_digging(_delta: float) -> void:
	if _digging_direction == DrillDirection.DOWN:
		
		"""
		var diff_y = _digging_target_global_pos.y - global_position.y
			if diff_y > 0: # Player has not yet reached the target y
				velocity.y = MAX_DRILL_VELOCITY
			
				# Calculate digging progress between 0 and 1
				var init_diff_y = _digging_initial_target_diff.y
				var digging_progress_y = (init_diff_y - diff_y) / init_diff_y
			
				# Set x position based on digging progress
				var init_diff_x = _digging_initial_target_diff.x
				var target_pos_x = _digging_target_global_pos.x
				var init_start_x = target_pos_x - init_diff_x
				global_position.x = init_start_x + init_diff_x * digging_progress_y
			
				# Set dug dirt texture when at least halfway through digging
				if digging_progress_y >= 0.5:
					earth.set_half_dug(_digging_target_cell, _digging_direction, is_facing_right())
			else: # Player is at least as deep as the target y
				finish_digging()
		elif _digging_direction == DrillDirection.SIDE:
			var diff_x: float
			if is_facing_right(): # digging right
				diff_x = _digging_target_global_pos.x - global_position.x
			else: # digging to the left
				diff_x = global_position.x - _digging_target_global_pos.x
			
			if diff_x > 0:
				if is_facing_right(): # Facing right
					velocity.x = MAX_DRILL_VELOCITY
				else: # Facing left
					velocity.x = -MAX_DRILL_VELOCITY
				
				# Calculate digging progress between 0 and 1
				var init_diff_x = abs(_digging_initial_target_diff.x)
				var digging_progress_x = (init_diff_x - diff_x) / init_diff_x
				
				# Set dug dirt texture when at least halfway through digging
				if digging_progress_x >= 0.5:
					earth.set_half_dug(_digging_target_cell, _digging_direction, is_facing_right())
			else:
				finish_digging() 
		"""





## In this method we process the movement as closely as possible to the original flash Motherload.
## The only exception to exact equality of the code in ActionScript is the delta time paradigm, 
## which Motherload does not use. 
func _physics_process_move(delta: float) -> void:
	var r: bool = Input.is_action_pressed("move_right")
	var l: bool = Input.is_action_pressed("move_left")
	var u: bool = Input.is_action_pressed("move_up")

	# Flash Motherload has frame-dependent physics calculations. We assume that our game runs at
	# the optimal flash fps (24) and adjust our delta time for it. This allows us to keep the
	# formulas in the decompiled code precisely the same, but still adjust for delta time.
	var delta_f: float = delta * Constants.FLASH_FPS
	
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
	# This handles movement outside of digging. 
	if !is_digging():
		# Check whether pod is not moving vertically and is on floor (grounded?)
		if int(yVel / 10.0) == 0 and is_on_floor():
			if r:
				xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight())) * delta_f, engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
				steam_count += 4
			elif l:
				xVel = maxf(xVel - (float(engine.base_power) / float(calculate_weight())) * delta_f, -engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
				steam_count += 4
			elif u and not is_turning(): # on floor and turning means pod can't take off
				yVel = maxf(yVel - (float(engine.base_power) / float(calculate_weight())) * 2 * delta_f, -engine.base_power / 10.0)
				fuel -= (engine.base_power / 50000.0) * delta_f
			
			# Apply friction using delta time
			xVel -= xVel * (1 - FRICTION) * delta_f
			
			# Set rotation to 0 degrees and rotor speed to 0 since we are on the ground
			self.rotation_degrees = 0
			rotor_speed = 0
		
		else: # Airborn case I guess? 
			if r:
				xVel = minf(xVel + (float(engine.base_power) / float(calculate_weight()) / 1.5) * delta_f, engine.base_power / 10.0)
				rotation_degrees = minf(rotation_degrees + (engine.base_power / 50.0) * delta_f, 15)
				fuel -= (engine.base_power / 50000.0) * delta_f
				rotor_speed = minf(rotor_speed + 0.3 * delta_f, 11)
				steam_count += 2
			elif l:
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
				steam_count += 4
			
			# Add air resistance and gravity
			xVel -= xVel * (1 - AIR_RESISTANCE) * delta_f
			yVel -= yVel * (1 - AIR_RESISTANCE) * delta_f
			yVel = minf(yVel + (GRAVITY / 30.0) * delta_f, 20.0)
			
			# The code applies this if the mode is "air", so I assume this means both flight and 
			# turning whilst flying. 
			if state_machine.is_current_any(["Flight","TurnFlight"]):
				rotor_speed = maxf(rotor_speed - rotor_speed * 0.05 * delta_f, 2)
	
	fuel -= (engine.base_power / 100000.0) * delta_f # Base fuel use?
	
	return Vector2(xVel, yVel)
