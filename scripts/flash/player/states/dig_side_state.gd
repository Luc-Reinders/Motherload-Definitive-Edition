extends State
class_name PlayerFlashDrillSideState

@export var player : PlayerFlash

func enter():
	player.animated_sprite.play(AnimatedSpritePlayerFlash.DRILL_SIDE_ANIM)
	player.start_digging(PlayerAbstract.DrillDirection.SIDE)

func update(_delta):
	if !player.is_digging():
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		# TODO: add functionality to drill again immediately
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_STATE)
		elif down: 
			transitioned.emit(self, StateMachinePlayerFlash.RETRACT_SIDE_DRILL_STATE)
		else:
			transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
	
