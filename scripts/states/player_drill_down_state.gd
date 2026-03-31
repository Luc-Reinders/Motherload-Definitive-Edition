extends State
class_name PlayerDrillDownState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"
@onready var player : Player = $"../../../Player"

func enter():
	animated_sprite.play("drill_down")
	player.start_drilling()
	
func exit():
	pass

# TODO: Needs more complicated logic once actual drilling is implemented. 
# This is dummy code for now to test whether it works at all
func update(_delta):
	if !player.drilling:
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		if up:
			transitioned.emit(self, "ExtendPropellerBottomDrill")
		elif down:
			player.start_drilling()
		else:
			transitioned.emit(self, "RetractBottomDrill")
	
