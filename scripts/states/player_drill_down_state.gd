extends State
class_name PlayerDrillDownState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"
@onready var player : Player = $"../../../Player"

func enter():
	animated_sprite.play("drill_down")
	player.start_drilling(Player.DrillDirection.DOWN)
	
func exit():
	pass

func update(_delta):
	if !player.drilling:
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, "ExtendPropellerBottomDrill")
		else:
			transitioned.emit(self, "RetractBottomDrill")
	
