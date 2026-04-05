extends State
class_name PlayerMoveState

# HALF DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"
@onready var player : Player = $"../../../Player"

func enter():
	animated_sprite.play("move")
	
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
		if not animated_sprite.flip_h: # Handle turn from left to right
			animated_sprite.flip_h = true
			transitioned.emit(self, "TurnGround")
		elif player.is_on_wall() and player.is_on_floor():
			transitioned.emit(self, "DrillSide")
	elif left:
		if animated_sprite.flip_h: # Handle turn from right to left
			animated_sprite.flip_h = false
			transitioned.emit(self, "TurnGround")
		elif player.is_on_wall() and player.is_on_floor(): 
			transitioned.emit(self, "DrillSide")
	else:
		# TODO: due to acceleration, pod may be moving even if no buttons are pressed
		transitioned.emit(self, "Idle")
		
