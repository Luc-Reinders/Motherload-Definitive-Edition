extends PlayerState
class_name PlayerFlashDrillDownState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.DRILL_DOWN_ANIM)
	player.start_digging(AbstractPlayer.DigDirection.DOWN)

func update(_delta):
	if !player.is_digging(): # Finished digging
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		elif down:
			player.start_digging(AbstractPlayer.DigDirection.DOWN)
		else:
			transitioned.emit(self, StateMachinePlayerFlash.RETRACT_BOTTOM_DRILL_STATE)
	
