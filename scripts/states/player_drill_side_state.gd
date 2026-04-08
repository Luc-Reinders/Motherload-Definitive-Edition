extends State
class_name PlayerDrillSideState

@export var player : PlayerAbstract

func enter():
	player.animated_sprite.play("drill_side")
	player.start_drilling(PlayerAbstract.DrillDirection.SIDE)
	
func exit():
	pass

func update(_delta):
	if !player.is_drilling():
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, "ExtendPropellerSideDrill")
		elif down: 
			transitioned.emit(self, "RetractSideDrill")
		else:
			transitioned.emit(self, "Idle")
	
