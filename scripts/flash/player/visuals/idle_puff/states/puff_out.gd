extends IdlePuffState
class_name PuffOutState

# Lasts 3 frames
const DURATION = 3.0 / Constants.FLASH_FPS

var time := 0.0



func enter():
	visuals.position.y += 1.0

func _process(delta: float) -> void:
	time += delta
	
	if time >= DURATION:
		transitioned.emit(self, IdlePuffStateMachine.INHALE_HALF_STATE)
