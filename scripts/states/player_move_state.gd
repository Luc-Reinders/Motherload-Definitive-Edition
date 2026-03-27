extends State
class_name PlayerMoveState

# HALF DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

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
	elif down: # TODO: Maybe slow down a bit before you are allowed to drill down
		transitioned.emit(self, "RetractSideDrill")
	else:
		# Handle grounded turns
		if right and not animated_sprite.flip_h:
			animated_sprite.flip_h = true
			transitioned.emit(self, "TurnGround")
		elif left and animated_sprite.flip_h:
			animated_sprite.flip_h = false
			transitioned.emit(self, "TurnGround")
		# TODO: check if standing still when adding acceleration
		elif not right and not left: 
			transitioned.emit(self, "Idle")
		
