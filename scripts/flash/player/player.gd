extends AbstractPlayer
class_name FlashPlayer





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
