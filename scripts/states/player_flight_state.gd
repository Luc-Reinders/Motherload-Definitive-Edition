extends State
class_name PlayerFlightState

@export var player : PlayerAbstract

func enter():
	player.animated_sprite.play("flight")
	
func exit():
	pass

func update(_delta):
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var down = Input.is_action_pressed("move_down")
	
	# Update animation speed depending on rotor speed. This formula is based on the decompiled
	# code from flash Motherload.
	player.animated_sprite.speed_scale = (PlayerFlash.FLASH_FPS/5.0) * player.rotor_speed
	
	if player.is_on_floor():
		if down:
			go_to_state("RetractPropellerBottomDrill")
		else:
			go_to_state("RetractPropellerSideDrill")
	else:
		# Handle airborn turns
		if right and not player.is_facing_right() and player.velocity.x > 0:
			# Turn right
			player.face_right()
			go_to_state("TurnFlight")
		elif left and player.is_facing_right() and player.velocity.x < 0:
			# Turn left
			player.face_left()
			go_to_state("TurnFlight")



func go_to_state(state_name: String):
	player.animated_sprite.speed_scale = 1
	transitioned.emit(self, state_name)
