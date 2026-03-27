extends State
class_name PlayerDrillSideState

# NOT DONE AND IMPLEMENTED

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("drill_side")
	
func exit():
	pass

# TODO: Needs logic once actual drilling is implemented. 
func update(_delta):
	pass
