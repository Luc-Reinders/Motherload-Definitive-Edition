extends State
class_name PlayerDrillSideState

@export var animated_sprite : AnimatedSprite2D
@export var player : Player

func enter():
	animated_sprite.play("drill_side")
	player.start_drilling(Player.DrillDirection.SIDE)
	
func exit():
	pass

func update(_delta):
	if !player.drilling:
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, "ExtendPropellerSideDrill")
		elif down: 
			transitioned.emit(self, "RetractSideDrill")
		else:
			transitioned.emit(self, "Idle")
	
