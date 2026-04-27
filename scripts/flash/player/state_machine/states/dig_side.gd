extends PlayerState
class_name PlayerFlashDrillSideState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.DRILL_SIDE_ANIM)
	player.start_digging(AbstractPlayer.DigDirection.SIDE)

func update(_delta):
	if !player.is_digging(): # Finished digging
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_STATE)
		elif down: 
			transitioned.emit(self, StateMachinePlayerFlash.RETRACT_SIDE_DRILL_STATE)
		else:
			transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
	
