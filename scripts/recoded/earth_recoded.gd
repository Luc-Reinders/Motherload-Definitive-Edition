extends EarthAbstract
class_name EarthRecoded

## Sets a tile to the half dug texture and handles the surrounding cave texture logic. This function
## handles the logic differently to the flash Motherload, by correcting for a texturing mistake 
## in the flash Motherload.
func set_half_dug(cell: Vector2i, drill_direction: PlayerAbstract.DigDirection, facing_right: bool) -> void:
	if drill_direction == PlayerAbstract.DigDirection.DOWN:
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_90)
		
		if cell.y <= 0: # Edge case when digging from ground level
			return
		
		# Get bit mask from the tile where you started digging
		var bitmask: Array[bool] = obtain_neighbor_bit_mask(cell + Vector2i(0, -1))
		var t: bool = bitmask[0]
		var r: bool = bitmask[2]
		var b_r: bool = bitmask[3]
		var b_l: bool = bitmask[5]
		var l: bool = bitmask[6]
		
		if (r or b_r) and (b_l or l): # For these cases the general texturing method works
			set_appropriate_cave_texture(cell + Vector2i(0, -1)) 
		# For all other cases the general texturing method breaks
		else:
			# From this point r and l represent the entire r or b_r and b_l or l clauses. We know
			# that r and b_r are false or b_l and l are false (or all variables are false). So if we
			# say that r is true, we really mean that both r and b_r are true since this is implied.
			# Additionally, note that either r or l is false.
			if t and r: # l must be false in this case
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE4, TileTransform.ROTATE_90)
			elif !t and r: # l must be false in this case
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE7, TileTransform.ROTATE_180)
			elif t and l: # r must be false in this case
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE4, TileTransform.ROTATE_90)
			elif !t and l: # r must be false in this case
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE7, TileSetAtlasSource.TRANSFORM_FLIP_V)
			elif t: # r and l are false
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE5, TileTransform.ROTATE_0)
			else: # t, r and l are false
				set_tile(cell + Vector2i(0,-1), Tiles.CAVE11, TileTransform.ROTATE_90)
		
	elif facing_right: # Player is digging to the right
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_0)
		
		# Get bit mask from the tile where you started digging. Note that we know that the tile
		# below the cell we started digging from is a full tile, since we are digging horizontally.
		# This simplifies the logic compared to the digging down case drastically.
		var bitmask: Array[bool] = obtain_neighbor_bit_mask(cell + Vector2i(-1, 0))
		var t: bool = bitmask[0]
		var t_r: bool = bitmask[1]
		var l: bool = bitmask[6]
		
		if t or t_r: # For these cases the general texturing method works
			set_appropriate_cave_texture(cell + Vector2i(-1, 0)) 
		else:
			if l: # t and t_r must be false
				set_tile(cell + Vector2i(-1,0), Tiles.CAVE4, TileTransform.ROTATE_270)
			else: # t, t_r and l must be false
				set_tile(cell + Vector2i(-1,0), Tiles.CAVE7,  TileTransform.ROTATE_270 | TileSetAtlasSource.TRANSFORM_FLIP_H)
	
	else: # Player is digging to the left. Analogous to drilling right, so read comments there.
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_180)
	
		var bitmask: Array[bool] = obtain_neighbor_bit_mask(cell + Vector2i(1, 0))
		var t: bool = bitmask[0]
		var r: bool = bitmask[2]
		var t_l: bool = bitmask[7]
		
		if t or t_l: # For these cases the general texturing method works
			set_appropriate_cave_texture(cell + Vector2i(1, 0)) 
		else:
			if r: # t and t_l must be false
				set_tile(cell + Vector2i(1,0), Tiles.CAVE4, TileTransform.ROTATE_180)
			else: # t, t_l and r must be false
				set_tile(cell + Vector2i(1,0), Tiles.CAVE7,  TileTransform.ROTATE_270)




func generate():
	pass # TODO: implement
