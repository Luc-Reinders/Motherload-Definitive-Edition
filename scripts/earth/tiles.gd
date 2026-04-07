extends Node
class_name Tiles

# All catagories of game tiles. The integers represent the column indices in
# which they appear in the sprite sheet.
const DIRT_TILE = 0
const MINERAL_TILE = 1
const ARTIFACT_TILE = 2
const ROCK_TILE = 3
const LAVA_TILE = 4
const GROUND_TILE = 5
const CAVE_TILE = 6
const HELL_TILE = 7
const MISC_TILE = 8


# Functions for direct checking of catagories
static func is_type(tile: Vector2i, type: int) -> bool:
	return tile.x == type

static func is_dirt_tile(tile: Vector2i) -> bool:
	return is_type(tile, DIRT_TILE)
static func is_mineral_tile(tile: Vector2i) -> bool:
	return is_type(tile, MINERAL_TILE)
static func is_artifact_tile(tile: Vector2i) -> bool:
	return is_type(tile, ARTIFACT_TILE)
static func is_rock_tile(tile: Vector2i) -> bool:
	return is_type(tile, ROCK_TILE)
static func is_lava_tile(tile: Vector2i) -> bool:
	return is_type(tile, LAVA_TILE)
static func is_ground_tile(tile: Vector2i) -> bool:
	return is_type(tile, GROUND_TILE)
static func is_cave_tile(tile: Vector2i) -> bool:
	return is_type(tile, CAVE_TILE)
static func is_hell_tile(tile: Vector2i) -> bool:
	return is_type(tile, HELL_TILE)
static func is_misc_tile(tile: Vector2i) -> bool:
	return is_type(tile, MISC_TILE)

## Checks whether the given tile has no texture
static func is_empty_tile(tile: Vector2i) -> bool:
	return tile == NONE

## Checks whether the tile has no texture, a cave texture or the half dug tile
static func is_air_tile(tile: Vector2i) -> bool:
	return is_cave_tile(tile) or is_empty_tile(tile) or tile == Tiles.HALF_DUG
## Checks whether the tile occupies space (player cannot move into it)
static func is_full_tile(tile: Vector2i) -> bool:
	return !is_air_tile(tile)
	





# All game tiles and their corresponding atlas coordinate
const DIRT1 = Vector2i(DIRT_TILE,0)
const DIRT2 = Vector2i(DIRT_TILE,1)
const DIRT3 = Vector2i(DIRT_TILE,2)
const DIRT4 = Vector2i(DIRT_TILE,3)
const DIRT5 = Vector2i(DIRT_TILE,4)

const IRONIUM = Vector2i(MINERAL_TILE,0)
const BRONZIUM = Vector2i(MINERAL_TILE,1)
const SILVERIUM = Vector2i(MINERAL_TILE,2)
const GOLDIUM = Vector2i(MINERAL_TILE,3)
const PLATINIUM = Vector2i(MINERAL_TILE,4)
const EINSTEINIUM = Vector2i(MINERAL_TILE,5)
const EMERALD = Vector2i(MINERAL_TILE,6)
const RUBY = Vector2i(MINERAL_TILE,7)
const DIAMOND = Vector2i(MINERAL_TILE,8)
const AMAZONITE = Vector2i(MINERAL_TILE,9)

const DINOSAUR_BONES = Vector2i(ARTIFACT_TILE,0)
const TREASURE = Vector2i(ARTIFACT_TILE,1)
const MARTIAN_SKELETON = Vector2i(ARTIFACT_TILE,2)
const RELIGIOUS_ARTIFACT = Vector2i(ARTIFACT_TILE,3)
const BLUEPRINT = Vector2i(ARTIFACT_TILE,4)

const ROCK1 = Vector2i(ROCK_TILE,0)
const ROCK2 = Vector2i(ROCK_TILE,1)
const ROCK3 = Vector2i(ROCK_TILE,2)

const LAVA1 = Vector2i(LAVA_TILE,0)
const LAVA2 = Vector2i(LAVA_TILE,1)
const LAVA3 = Vector2i(LAVA_TILE,2)

const PAVEMENT = Vector2i(GROUND_TILE,0)
const PAVEMENT_RIGHT = Vector2i(GROUND_TILE,1)
const PAVEMENT_LEFT = Vector2i(GROUND_TILE,2)
const GRASS1 = Vector2i(GROUND_TILE,3)
const GRASS2 = Vector2i(GROUND_TILE,4)

const CAVE1 = Vector2i(CAVE_TILE,0)
const CAVE2 = Vector2i(CAVE_TILE,1)
const CAVE3 = Vector2i(CAVE_TILE,2)
const CAVE4 = Vector2i(CAVE_TILE,3)
const CAVE5 = Vector2i(CAVE_TILE,4)
const CAVE6 = Vector2i(CAVE_TILE,5)
const CAVE7 = Vector2i(CAVE_TILE,6)
const CAVE8 = Vector2i(CAVE_TILE,7)
const CAVE9 = Vector2i(CAVE_TILE,8)
const CAVE10 = Vector2i(CAVE_TILE,9)
const CAVE11 = Vector2i(CAVE_TILE,10)
const CAVE12 = Vector2i(CAVE_TILE,11)
const CAVE13 = Vector2i(CAVE_TILE,12)

const HELL_ROOF1 = Vector2i(HELL_TILE,0)
const HELL_ROOF2 = Vector2i(HELL_TILE,1)
const HELL_FLOOR1 = Vector2i(HELL_TILE,2)
const HELL_FLOOR2 = Vector2i(HELL_TILE,3)
const BLACK = Vector2i(HELL_TILE,4)

const HALF_DUG = Vector2i(MISC_TILE,0)

const NONE = Vector2i(-1,-1)
