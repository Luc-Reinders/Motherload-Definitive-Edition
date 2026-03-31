extends TileMapLayer
class_name Earth

const SOURCE_ID = 0

# TODO: Use enums instead of strings?
const TILES_ATLAS = {
	"dirt": Vector2i(0, 0),
	"dug_dirt": Vector2i(1,2)
}

func set_tile(cell: Vector2i, tile_name: String) -> void:
	set_cell(cell, SOURCE_ID, TILES_ATLAS[tile_name])
	
