extends EarthAbstract
class_name EarthFlash

## Sets a tile to the half dug texture and handles the surrounding cave texture logic. This function 
## handles the logic identically to the flash version of Motherload, which has a texturing mistake. 
func set_half_dug(cell: Vector2i, drill_direction: PlayerAbstract.DigDirection, facing_right: bool) -> void:
	# TODO: Commented correct code out to replace with recoded version for testing purposes. Re-enable "false" code later
	
	"""
	if drill_direction == PlayerAbstract.DigDirection.DOWN:
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_90)
		set_appropriate_cave_texture(cell + Vector2i(0, -1)) 
	elif facing_right: # Player is digging to the right
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_0)
		set_appropriate_cave_texture(cell + Vector2i(-1, 0)) 
	else: # Player is digging to the left
		set_tile(cell, Tiles.HALF_DUG, TileTransform.ROTATE_180)
		set_appropriate_cave_texture(cell + Vector2i(1, 0)) 
	"""
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






# Generation

const MINERAL_RATE: int = 65 # Constant from flash code

# TODO: Sizes might be inaccurate to real game.
const FLASH_EARTH_HEIGHT: int = 600
const EARTH_WIDTH: int = 34
const EARTH_HEIGHT: int = FLASH_EARTH_HEIGHT - 8

# TODO: Temporary solution for rng
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

## TODO: Grass generation?

## This method will generate the earth as close as possible to the original flash Motherload.
## Much of the code is structurally identical to the ActionScript code of flash Motherload. 
func generate() -> void:
	rng.seed = 2
	
	var rotations = EarthAbstract.TileTransform.values()
	
	for x in range(-int(EARTH_WIDTH/2.0), int(EARTH_WIDTH/2.0)):
		for y in range(1, EARTH_HEIGHT):
			var loc_1 = y + 5 # offset to match flash y-variable
			
			var tile: Vector2i
			
			# Obtain Random rotation
			var tile_rotation : EarthAbstract.TileTransform = rotations[rng.randi_range(0, rotations.size() - 1)]
			
			# In this rng case, a mineral or artifact will be generated
			if rng.randi_range(0,4) == 0: 
				if rng.randi_range(0,4) == 0: 
					if rng.randi_range(0,4) == 0: 
						if rng.randi_range(0,3) == 0 and loc_1 > 80: # Instead of mineral, give artifact
							tile = Vector2i(Tiles.Type.ARTIFACT, rng.randi_range(0,3))
							# Edge case; Treasure must appear right-side up
							if tile == Tiles.TREASURE:
								tile_rotation = EarthAbstract.TileTransform.ROTATE_0
						else: # probably gives rare mineral
							tile = generate_random_mineral_tile(loc_1, Tiles.SILVERIUM)
					else: # may give rare mineral
						tile = generate_random_mineral_tile(loc_1, Tiles.BRONZIUM)
				else: # most likely gives common mineral
					tile = generate_random_mineral_tile(loc_1, Tiles.IRONIUM)
			
			# In this rng case, an empty tile will be generated
			elif rng.randi_range(0,2) == 0: 
				tile = Tiles.NONE
			
			# Otherwise, a default dirt tile, rock tile or lava tile is generated.
			else:
				# Check whether rock/lava can be generated and add an rng check
				if loc_1 * 1.5 > FLASH_EARTH_HEIGHT / 3.0 and rng.randi_range(0, int(15 * (float(FLASH_EARTH_HEIGHT - loc_1)/float(FLASH_EARTH_HEIGHT)) - 1)) == 0:
					# If this rng check fails, tile will be a rock  tile
					if (loc_1/2.0) * 1.5 > FLASH_EARTH_HEIGHT / 3.0 and rng.randi_range(0,1) == 0:
						# If this rng check fails, tile will be a lava tile
						if (loc_1/3.0) * 1.5 > FLASH_EARTH_HEIGHT / 3.0 and rng.randi_range(0,1) == 0:
							tile = Tiles.DIRT1 # TODO: Is this supposed to be a natural glas cloud?
						else: 
							tile = Vector2i(Tiles.Type.LAVA, rng.randi_range(0, Tiles.LAVA3.y))
					else: 
						tile = Vector2i(Tiles.Type.ROCK, rng.randi_range(0, Tiles.ROCK3.y))
				else: 
					tile = Vector2i(Tiles.Type.DIRT, rng.randi_range(0, Tiles.DIRT5.y))
			
			self.set_tile(Vector2i(x,y), tile, tile_rotation)
	
	generate_cave_tiles(Vector2i(-EARTH_WIDTH/2.0, 0), Vector2i(EARTH_WIDTH/2.0 - 1, EARTH_HEIGHT))



## Gets a random mineral tile at the given vertical level loc_1
func generate_random_mineral_tile(loc_1: int, minimal_mineral: Vector2i) -> Vector2i:
	var random_offset: int = rng.randi_range(0, int(float(loc_1) / float(MINERAL_RATE)) + 1)
	return Vector2i(Tiles.Type.MINERAL, mini(random_offset + minimal_mineral.y, Tiles.AMAZONITE.y))

## Adds cave tiles to the generated earth.
func generate_cave_tiles(start: Vector2i, end: Vector2i) -> void:
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			set_appropriate_cave_texture(Vector2i(x,y))
