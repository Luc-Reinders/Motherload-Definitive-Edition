extends TileMapLayer
class_name Earth

const TILE_SOURCE_ID = 0

enum TileTransform {
	ROTATE_0 = 0,
	ROTATE_90 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	ROTATE_180 = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	ROTATE_270 = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

func _ready():
	set_appropriate_cave_texture(Vector2i(0,0))

## We are using atlas coordinates to identify cells. This function is a shortcut
func get_tile(cell: Vector2i) -> Vector2i:
	return get_cell_atlas_coords(cell)

## Shorthand function: The source id for all tiles is the same since all tiles 
## share the same sprite sheet. 
func set_tile(coords: Vector2i, atlas_coords: Vector2i, alternative_tile: int = 0) -> void:
	set_cell(coords, TILE_SOURCE_ID, atlas_coords, alternative_tile)



## If the given tile is empty, it will set this tile to the appropriate cave 
## texture (given it needs a cave texture, otherwise it will skip)
func set_appropriate_cave_texture(cell: Vector2i) -> void:
	var tile: Vector2i = get_cell_atlas_coords(cell)
	
	if Tiles.is_full_tile(tile):
		return
	
	var bitmask : Array[bool] = obtain_neighbor_bit_mask(cell)
	
	# All individual bits of the mask
	var t: bool = bitmask[0]
	var t_r: bool = bitmask[1]
	var r: bool = bitmask[2]
	var b_r: bool = bitmask[3]
	var b: bool = bitmask[4]
	var b_l: bool = bitmask[5]
	var l: bool = bitmask[6]
	var t_l: bool = bitmask[7]
	
	# All pattern cases are hardcoded. Ugly as fuck, but it works and it does 
	# not have to be scalable, so fuck it.
	if !t and !t_r and !r and !b_r and !b and !b_l and !l and !t_l:
		set_tile(cell, Tiles.NONE)
		
	elif t and r and b and !l:
		set_tile(cell, Tiles.CAVE1, TileTransform.ROTATE_0)
	elif !t and r and b and l:
		set_tile(cell, Tiles.CAVE1, TileTransform.ROTATE_90)
	elif t and !r and b and l:
		set_tile(cell, Tiles.CAVE1, TileTransform.ROTATE_180)
	elif t and r and !b and l:
		set_tile(cell, Tiles.CAVE1, TileTransform.ROTATE_270)

	elif t and !r and b and !l:
		set_tile(cell, Tiles.CAVE2, TileTransform.ROTATE_0)
	elif !t and r and !b and l:
		set_tile(cell, Tiles.CAVE2, TileTransform.ROTATE_90)
	
	elif t and !r and !b and !l:
		set_tile(cell, Tiles.CAVE3, TileTransform.ROTATE_0)
	elif !t and r and !b and !l:
		set_tile(cell, Tiles.CAVE3, TileTransform.ROTATE_90)
	elif !t and !r and b and !l:
		set_tile(cell, Tiles.CAVE3, TileTransform.ROTATE_180)
	elif !t and !r and !b and l:
		set_tile(cell, Tiles.CAVE3, TileTransform.ROTATE_270)

	elif t and !r and b_r and !b and l:
		set_tile(cell, Tiles.CAVE4, TileTransform.ROTATE_0)
	elif t and r and !b and b_l and !l:
		set_tile(cell, Tiles.CAVE4, TileTransform.ROTATE_90)
	elif !t and r and b and !l and t_l:
		set_tile(cell, Tiles.CAVE4, TileTransform.ROTATE_180)
	elif !t and t_r and !r and b and l:
		set_tile(cell, Tiles.CAVE4, TileTransform.ROTATE_270)

	elif t and !r and b_r and !b and b_l and !l:
		set_tile(cell, Tiles.CAVE5, TileTransform.ROTATE_0)
	elif !t and r and !b and b_l and !l and t_l:
		set_tile(cell, Tiles.CAVE5, TileTransform.ROTATE_90)
	elif !t and t_r and !r and b and !l and t_l:
		set_tile(cell, Tiles.CAVE5, TileTransform.ROTATE_180)
	elif !t and t_r and !r and b_r and !b and l:
		set_tile(cell, Tiles.CAVE5, TileTransform.ROTATE_270)

	elif t and !r and !b_r and !b and l:
		set_tile(cell, Tiles.CAVE6, TileTransform.ROTATE_0)
	elif t and r and !b and !b_l and !l:
		set_tile(cell, Tiles.CAVE6, TileTransform.ROTATE_90)
	elif !t and r and b and !l and !t_l:
		set_tile(cell, Tiles.CAVE6, TileTransform.ROTATE_180)
	elif !t and !t_r and !r and b and l:
		set_tile(cell, Tiles.CAVE6, TileTransform.ROTATE_270)



## Gets adjacent and diagonal neighbor cells sorted in clock-wise order starting
## from the top neigbor
# TODO: perhaps for optimization, make all directions constants?
func get_neighboring_cells(cell: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	
	neighbors.append(cell + Vector2i(0,-1)) # top
	neighbors.append(cell + Vector2i(1,-1)) # top right
	neighbors.append(cell + Vector2i(1, 0)) # right
	neighbors.append(cell + Vector2i(1, 1)) # bottom right
	neighbors.append(cell + Vector2i(0, 1)) # bottom
	neighbors.append(cell + Vector2i(-1,1)) # bottom left
	neighbors.append(cell + Vector2i(-1,0)) # left
	neighbors.append(cell + Vector2i(-1,-1)) # top left
	
	return neighbors

## Obtains a bit mask, which represents for each neighbour of the tile whether
## there is a filled tile next to it (this counts sides and diagonals).
## Array is in clock-wise order starting from the top neighbor.
func obtain_neighbor_bit_mask(cell: Vector2i) -> Array[bool]:
	var neighboring_cells: Array[Vector2i] = get_neighboring_cells(cell)
	
	var bit_mask: Array[bool] = []
	# Sets bit to true for each neighbor if tile occupies space, otherwise false
	for neighbor_cell in neighboring_cells:
		bit_mask.append(Tiles.is_full_tile(get_cell_atlas_coords(neighbor_cell)))
	
	return bit_mask
