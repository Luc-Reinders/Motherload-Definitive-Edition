extends State
class_name PlayerDrillDownState

@export var player : PlayerAbstract

func enter():
	player.animated_sprite.play("drill_down")
	player.start_drilling(PlayerAbstract.DrillDirection.DOWN)
	
func exit():
	pass

func update(_delta):
	if !player.is_drilling():
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, "ExtendPropellerBottomDrill")
		else:
			transitioned.emit(self, "RetractBottomDrill")
	
