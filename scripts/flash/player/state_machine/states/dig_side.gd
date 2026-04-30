extends PlayerState
class_name PlayerFlashDrillSideState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.DRILL_SIDE_ANIM)
	anim_sprite.start_shaking(AbstractPlayer.DigDirection.SIDE)
	player.start_digging(AbstractPlayer.DigDirection.SIDE)

func update(_delta):
	# Digging has finished. Go to next appropriate state.
	if !player.is_digging(): 
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		if up:
			go_to_state(StateMachinePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_STATE)
		elif down: 
			go_to_state(StateMachinePlayerFlash.RETRACT_SIDE_DRILL_STATE)
		else:
			go_to_state(StateMachinePlayerFlash.MOVE_STATE)

func go_to_state(state_name: StringName):
	anim_sprite.stop_shaking()
	transitioned.emit(self, state_name)
