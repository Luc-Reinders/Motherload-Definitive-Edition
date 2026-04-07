extends EarthGenerator

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
func generate(earth: Earth) -> void:
	rng.seed = 2
	
	var rotations = Earth.TileTransform.values()
	
	for x in range(-int(EARTH_WIDTH/2.0), int(EARTH_WIDTH/2.0)):
		for y in range(1, EARTH_HEIGHT):
			var loc_1 = y + 5 # offset to match flash y-variable
			
			var tile: Vector2i
			
			# Obtain Random rotation
			var rotation : Earth.TileTransform = rotations[rng.randi_range(0, rotations.size() - 1)]
			
			# In this rng case, a mineral or artifact will be generated
			if rng.randi_range(0,4) == 0: 
				if rng.randi_range(0,4) == 0: 
					if rng.randi_range(0,4) == 0: 
						if rng.randi_range(0,3) == 0 and loc_1 > 80: # Instead of mineral, give artifact
							tile = Vector2i(Tiles.ARTIFACT_TILE, rng.randi_range(0,3))
							# Edge case; Treasure must appear right-side up
							if tile == Tiles.TREASURE:
								rotation = Earth.TileTransform.ROTATE_0
						else: # probably gives rare mineral
							tile = generate_random_mineral_tile(loc_1, Tiles.SILVERIUM)
					else: # may give rarer mineral
						tile = generate_random_mineral_tile(loc_1, Tiles.BRONZIUM)
				else: # most likely give common mineral
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
							tile = Vector2i(Tiles.LAVA_TILE, Tiles.LAVA3.y)
					else: 
						tile = Vector2i(Tiles.ROCK_TILE, Tiles.ROCK3.y)
				else: 
					tile = Vector2i(Tiles.DIRT_TILE, Tiles.DIRT5.y)
			
			earth.set_tile(Vector2i(x,y), tile, rotation)
	
	generate_cave_tiles(earth, Vector2i(-EARTH_WIDTH/2.0, 0), Vector2i(EARTH_WIDTH/2.0 - 1, EARTH_HEIGHT))


func generate_random_mineral_tile(loc_1: int, minimal_mineral: Vector2i) -> Vector2i:
	var random_offset: int = rng.randi_range(0, int(float(loc_1) / float(MINERAL_RATE)) + 1)
	return Vector2i(Tiles.MINERAL_TILE, mini(random_offset + minimal_mineral.y, Tiles.AMAZONITE.y))
