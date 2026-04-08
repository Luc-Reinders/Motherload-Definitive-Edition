extends State
class_name PlayerIdleState

# DONE

@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("idle")
	
func exit():
	pass

func update(_delta):
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	if up:
		transitioned.emit(self, "ExtendPropellerSideDrill")
	elif down:
		transitioned.emit(self, "RetractSideDrill")
	if right or left:
		transitioned.emit(self, "Move")
