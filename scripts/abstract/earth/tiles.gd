extends Node
class_name Tiles

# All catagories of game tiles. The integers represent the column indices in
# which they appear in the sprite sheet.
enum Type {
	DIRT = 0,
	MINERAL = 1,
	ARTIFACT = 2,
	ROCK = 3,
	LAVA = 4,
	GROUND = 5,
	CAVE = 6,
	HELL = 7,
	MISC = 8
}


# Functions for direct checking of catagories
static func is_type(tile: Vector2i, type: int) -> bool:
	return tile.x == type

static func is_dirt_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.DIRT)
static func is_mineral_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.MINERAL)
static func is_artifact_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.ARTIFACT)
static func is_rock_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.ROCK)
static func is_lava_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.LAVA)
static func is_ground_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.GROUND)
static func is_cave_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.CAVE)
static func is_hell_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.HELL)
static func is_misc_tile(tile: Vector2i) -> bool:
	return is_type(tile, Type.MISC)

## Checks whether the given tile has no texture
static func is_empty_tile(tile: Vector2i) -> bool:
	return tile == NONE

## Checks whether the tile has no texture, a cave texture or the half dug tile
static func is_air_tile(tile: Vector2i) -> bool:
	return is_cave_tile(tile) or is_empty_tile(tile) or tile == Tiles.HALF_DUG
## Checks whether the tile occupies space (player cannot move into it)
static func is_full_tile(tile: Vector2i) -> bool:
	return !is_air_tile(tile)

## Checks whether the given tile is a tile that can be dug by the player
static func is_diggable_tile(tile: Vector2i) -> bool:
	return not is_air_tile(tile) and not is_hard_tile(tile)
## Hard tiles are full tiles that are undiggable
static func is_hard_tile(tile: Vector2i) -> bool:
	return is_rock_tile(tile) or is_hell_tile(tile)





# All game tiles and their corresponding atlas coordinate
const DIRT1 := Vector2i(Type.DIRT,0)
const DIRT2 := Vector2i(Type.DIRT,1)
const DIRT3 := Vector2i(Type.DIRT,2)
const DIRT4 := Vector2i(Type.DIRT,3)
const DIRT5 := Vector2i(Type.DIRT,4)

const IRONIUM := Vector2i(Type.MINERAL,0)
const BRONZIUM := Vector2i(Type.MINERAL,1)
const SILVERIUM := Vector2i(Type.MINERAL,2)
const GOLDIUM := Vector2i(Type.MINERAL,3)
const PLATINIUM := Vector2i(Type.MINERAL,4)
const EINSTEINIUM := Vector2i(Type.MINERAL,5)
const EMERALD := Vector2i(Type.MINERAL,6)
const RUBY := Vector2i(Type.MINERAL,7)
const DIAMOND := Vector2i(Type.MINERAL,8)
const AMAZONITE := Vector2i(Type.MINERAL,9)

const DINOSAUR_BONES := Vector2i(Type.ARTIFACT,0)
const TREASURE := Vector2i(Type.ARTIFACT,1)
const MARTIAN_SKELETON := Vector2i(Type.ARTIFACT,2)
const RELIGIOUS_ARTIFACT := Vector2i(Type.ARTIFACT,3)
const BLUEPRINT := Vector2i(Type.ARTIFACT,4)

const ROCK1 := Vector2i(Type.ROCK,0)
const ROCK2 := Vector2i(Type.ROCK,1)
const ROCK3 := Vector2i(Type.ROCK,2)

const LAVA1 := Vector2i(Type.LAVA,0)
const LAVA2 := Vector2i(Type.LAVA,1)
const LAVA3 := Vector2i(Type.LAVA,2)

const PAVEMENT := Vector2i(Type.GROUND,0)
const PAVEMENT_RIGHT := Vector2i(Type.GROUND,1)
const PAVEMENT_LEFT := Vector2i(Type.GROUND,2)
const GRASS1 := Vector2i(Type.GROUND,3)
const GRASS2 := Vector2i(Type.GROUND,4)

const CAVE1 := Vector2i(Type.CAVE,0)
const CAVE2 := Vector2i(Type.CAVE,1)
const CAVE3 := Vector2i(Type.CAVE,2)
const CAVE4 := Vector2i(Type.CAVE,3)
const CAVE5 := Vector2i(Type.CAVE,4)
const CAVE6 := Vector2i(Type.CAVE,5)
const CAVE7 := Vector2i(Type.CAVE,6)
const CAVE8 := Vector2i(Type.CAVE,7)
const CAVE9 := Vector2i(Type.CAVE,8)
const CAVE10 := Vector2i(Type.CAVE,9)
const CAVE11 := Vector2i(Type.CAVE,10)
const CAVE12 := Vector2i(Type.CAVE,11)
const CAVE13 := Vector2i(Type.CAVE,12)

const HELL_ROOF1 := Vector2i(Type.HELL,0)
const HELL_ROOF2 := Vector2i(Type.HELL,1)
const HELL_FLOOR1 := Vector2i(Type.HELL,2)
const HELL_FLOOR2 := Vector2i(Type.HELL,3)
const BLACK := Vector2i(Type.HELL,4)

const HALF_DUG := Vector2i(Type.MISC,0)

const NONE := Vector2i(-1,-1)
