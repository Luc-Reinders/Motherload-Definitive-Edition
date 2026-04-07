extends Node
class_name EarthGenerator

## Generates the earth when loading in the game. This includes dirt-, minerals-, artifacts-,
## rocks-, and lava generation.
@warning_ignore("unused_parameter")
func generate(earth: Earth) -> void:
	push_error("generate() must be overriden")

## Adds cave tiles to the generated earth.
## @param start The top left of the earth
## @param end The bottom right of the earth
func generate_cave_tiles(earth: Earth, start: Vector2i, end: Vector2i) -> void:
	for x in range(start.x, end.x + 1):
		for y in range(start.y, end.y + 1):
			earth.set_appropriate_cave_texture(Vector2i(x,y))
