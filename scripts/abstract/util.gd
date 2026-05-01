class_name Util

## Motherload has frame-dependent physics calculations. This means that the velocities used in the 
## AS code have unit px/frame. The velocities in Godot have unit px/s. To make conversions between 
## Godot's- and AS's velocities, we must fix an FPS value for Flash Motherload. Once we do that, 
## we can easily convert between the velocities like this:
## VelAS = velocity_godot / FLASH_FPS
## velocity_godot = VelAS * FLASH_FPS
static func convert_to_AS_velocity(godot_velocity: float) -> float:
	return godot_velocity / Constants.FLASH_FPS 
static func convert_to_godot_velocity(ASVel: float) -> float:
	return ASVel * Constants.FLASH_FPS
