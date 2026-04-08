extends State
class_name PlayerFlightState

@export var player : Player
@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("flight")
	
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
		if right and not animated_sprite.flip_h:
			animated_sprite.flip_h = true
			transitioned.emit(self, "TurnFlight")
		elif left and animated_sprite.flip_h:
			animated_sprite.flip_h = false
			transitioned.emit(self, "TurnFlight")
		
