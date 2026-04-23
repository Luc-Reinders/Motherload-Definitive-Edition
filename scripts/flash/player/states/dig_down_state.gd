extends State
class_name PlayerFlashDrillDownState

@export var player : PlayerFlash

func enter():
	player.animated_sprite.play(AnimatedSpritePlayerFlash.DRILL_DOWN_ANIM)
	player.start_digging(PlayerAbstract.DigDirection.DOWN)

func update(_delta):
	if !player.is_digging(): # Finished digging
		player.velocity = Vector2.ZERO
		
		var up = Input.is_action_pressed("move_up")
		var down = Input.is_action_pressed("move_down")
		
		if up:
			transitioned.emit(self, StateMachinePlayerFlash.EXTEND_ROTOR_BOTTOM_DRILL_STATE)
		elif down:
			player.start_digging(PlayerAbstract.DigDirection.DOWN)
		else:
			transitioned.emit(self, StateMachinePlayerFlash.RETRACT_BOTTOM_DRILL_STATE)
	
