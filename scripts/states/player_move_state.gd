extends State
class_name PlayerMoveState

@export var player : PlayerAbstract

func enter():
	player.animated_sprite.play("move")
	
func exit():
	pass

func update(_delta):
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	# TODO: Once drilling is implemented, add transition to side drill state
	
	if up:
		transitioned.emit(self, "ExtendPropellerSideDrill")
	elif down: # TODO: Movement speed need to be slow before you are allowed to drill down
		transitioned.emit(self, "RetractSideDrill")
	elif right:
		if not player.is_facing_right(): # Handle turn from left to right
			player.face_right()
			transitioned.emit(self, "TurnGround")
		elif player.is_on_wall() and player.is_on_floor():
			transitioned.emit(self, "DrillSide")
	elif left:
		if player.is_facing_right(): # Handle turn from right to left
			player.face_left()
			transitioned.emit(self, "TurnGround")
		elif player.is_on_wall() and player.is_on_floor(): 
			transitioned.emit(self, "DrillSide")
	else:
		# TODO: due to acceleration, pod may be moving even if no buttons are pressed
		transitioned.emit(self, "Idle")
		
