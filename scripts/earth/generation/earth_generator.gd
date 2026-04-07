extends Node
class_name EarthGenerator

## Generates the earth when loading in the game. This includes dirt-, minerals-, artifacts-,
## rocks-, and lava generation.
@warning_ignore("unused_parameter")
func generate(earth: Earth) -> void:
	push_error("generate() must be overriden")
	
