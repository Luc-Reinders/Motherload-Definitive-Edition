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
	
	# TODO: Adapt propeller anim speed based on vertical movement speed
	
	if player.is_on_floor():
		if down:
			transitioned.emit(self, "RetractPropellerBottomDrill")
		else:
			transitioned.emit(self, "RetractPropellerSideDrill")
	else:
		# Handle airborn turns
		if right and not player.is_facing_right():
			player.face_right()
			transitioned.emit(self, "TurnFlight")
		elif left and player.is_facing_right():
			player.face_left()
			transitioned.emit(self, "TurnFlight")
		
