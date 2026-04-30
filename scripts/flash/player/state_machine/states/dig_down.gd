extends PlayerState
class_name PlayerFlashDrillDownState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.DRILL_DOWN_ANIM)
	anim_sprite.start_shaking(AbstractPlayer.DigDirection.DOWN)
	player.start_digging(AbstractPlayer.DigDirection.DOWN)

func update(_delta):
	# Digging has finished. Go to next appropriate state or keep on digging down.
	if !player.is_digging(): 
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		var tile = player.earth.get_tile(player.get_cell_below())
		
		if up:
			go_to_state(StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		elif down:
			if Tiles.is_diggable_tile(tile):
				player.start_digging(AbstractPlayer.DigDirection.DOWN)
			elif Tiles.is_hard_tile(tile):
				pass # TODO: make clink noise
			else: # tile is air tile
				go_to_state(StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		else:
			if Tiles.is_full_tile(tile):
				go_to_state(StateMachinePlayerFlash.RETRACT_BOTTOM_DRILL_STATE)
			else:
				go_to_state(StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)

func go_to_state(state_name: StringName):
	anim_sprite.stop_shaking()
	transitioned.emit(self, state_name)
