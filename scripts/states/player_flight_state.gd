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
	
	# The next (seemingly simple) line of code requires some explanation. Flash Motherload changes
	# their animation speed is done in the most peculiar way. The rotor animation consists of 
	# 5 frames, and they seem to duplicate each rotor animation 4 times (so we are left with
	# 25 frames in total). These are put in order, so every "frame" actually lasts 5 frames. Each
	# update they move the animation int(rotorVel) steps ahead. So if rotorVel is very low, some
	# "frames" last multiple frames, giving the illusion of the animation moving slower
	# Now, Godot is not retarded, so we can modularly change the animation speed scale. Intuitvely
	# the speed scale should scale linearly with the rotor speed. Since rotorVel = 5 means that
	# each "frame" lasts one frame, we obtain the corresponding linear formula.
	# Additional example: rotorVel can be at most ~10 when setting the frame variable. This means 
	# that it runs through 10 "frames" out of 25 (or 2 "real" frames), so we have 
	# rotor speed = 10/5 = 2, which corresponds to double the FPS, which coincides with what
	# the actionscript code would do.
	player.animated_sprite.speed_scale = (player.rotor_speed/5.0)
	
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
