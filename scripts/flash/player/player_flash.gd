extends PlayerAbstract
class_name PlayerFlash





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





# Old digging code. TODO: Remove later
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
		elif _digging_direction == DigDirection.SIDE:
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
