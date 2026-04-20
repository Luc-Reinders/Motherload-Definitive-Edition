extends State
class_name PlayerFlashDrillDownState

@export var player : PlayerFlash

func enter():
	player.animated_sprite.play(AnimatedSpritePlayerFlash.DRILL_DOWN_ANIM)
	player.start_digging(PlayerAbstract.DrillDirection.DOWN)

func update(_delta):
	if !player.is_digging():
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		else:
			transitioned.emit(self, StateMachinePlayerFlash.RETRACT_BOTTOM_DRILL_STATE)
	
