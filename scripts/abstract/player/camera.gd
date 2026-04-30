extends Camera2D
class_name PlayerCamera

const DEADZONE_X := 75
const DEADZONE_Y := 25

# In motherload this value was 10, but it needed to be adjusted for better accuracy
const DRAG_SPEED := 13.0 

@export var player: AbstractPlayer

func _process(_delta: float) -> void:
	var dif := player.global_position - global_position
	
	# Code based on Motherload logic
	if abs(dif.x) > DEADZONE_X:
		var velocity_x = (dif.x - sign(dif.x) * DEADZONE_X) / DRAG_SPEED
		global_position.x += velocity_x
	if abs(dif.y) > DEADZONE_Y:
		var velocity_y = (dif.y - sign(dif.y) * DEADZONE_Y) / DRAG_SPEED
		global_position.y += velocity_y
