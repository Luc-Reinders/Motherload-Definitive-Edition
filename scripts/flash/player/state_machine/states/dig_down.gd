extends PlayerState
class_name PlayerFlashDrillDownState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.DRILL_DOWN_ANIM)
	player.start_digging(AbstractPlayer.DigDirection.DOWN)

func update(_delta):
	if !player.is_digging(): # Finished digging
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		var tile = player.earth.get_tile(player.get_cell_below())
		
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		elif down:
			if Tiles.is_diggable_tile(tile):
				player.start_digging(AbstractPlayer.DigDirection.DOWN)
			elif Tiles.is_hard_tile(tile):
				pass # TODO: make clink noise
			else: # tile is air tile
				transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		else:
			if Tiles.is_full_tile(tile):
				transitioned.emit(self, StateMachinePlayerFlash.RETRACT_BOTTOM_DRILL_STATE)
			else:
				transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
	
