extends PlayerState
class_name PlayerFlashMoveState



func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.MOVE_ANIM)
	visuals.start_idle_puffing()

func update(_delta):
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	# TODO: Give better explanation of this magic formula?
	# Update animation speed depending on x velocity. This formula is based on the decompiled
	# code from flash Motherload.
	anim_sprite.speed_scale = (4.0 * abs(player.velocity.x)) / (5.0 * Constants.FLASH_FPS)
	
	if up or not player.is_on_floor(): # enter flight
		go_to_state(StateMachinePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_STATE)
	elif down and player.is_on_floor(): # attempt digging down
		var dig_check: AbstractPlayer.DigCheckResult = player.dig_check(AbstractPlayer.DigDirection.DOWN)
		if dig_check == AbstractPlayer.DigCheckResult.VALID: 
			# Digging success, start preparing for digging down
			player.perpare_for_digging()
			go_to_state(StateMachinePlayerFlash.RETRACT_SIDE_DRILL_STATE)
		elif dig_check == AbstractPlayer.DigCheckResult.HARD:
			pass #TODO: add "clink" sound effect here
	elif right:
		if not player.is_facing_right() and (player.velocity.x > 0 or player.is_on_wall()): 
			# Turn right
			player.face_right()
			go_to_state(StateMachinePlayerFlash.TURN_GROUND_STATE)
		elif player.is_on_wall() and player.is_on_floor():
			var dig_check: AbstractPlayer.DigCheckResult = player.dig_check(AbstractPlayer.DigDirection.SIDE)
			if dig_check == AbstractPlayer.DigCheckResult.VALID: # TODO: add clink? What does motherload do?
				player.perpare_for_digging()
				go_to_state(StateMachinePlayerFlash.DIG_SIDE_STATE)
	elif left:
		if player.is_facing_right() and (player.velocity.x < 0 or player.is_on_wall()):
			# Turn left
			player.face_left()
			go_to_state(StateMachinePlayerFlash.TURN_GROUND_STATE)
		elif player.is_on_wall() and player.is_on_floor(): 
			var dig_check: AbstractPlayer.DigCheckResult = player.dig_check(AbstractPlayer.DigDirection.SIDE)
			if dig_check == AbstractPlayer.DigCheckResult.VALID: # TODO: add clink? What does motherload do?
				player.perpare_for_digging()
				go_to_state(StateMachinePlayerFlash.DIG_SIDE_STATE)


func go_to_state(state_name: String):
	player.anim_sprite.speed_scale = 1
	player.visuals.stop_idle_puffing()
	transitioned.emit(self, state_name)
