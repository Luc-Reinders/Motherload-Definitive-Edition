extends IdlePuffState
class_name InhaleHalfState

# Lasts 1 frame
const DURATION = 1.0 / Constants.FLASH_FPS

var time := 0.0



func enter():
	visuals.position.y -= 0.5

func _process(delta: float) -> void:
	time += delta
	
	if time >= DURATION:
		transitioned.emit(self, IdlePuffStateMachine.INHALE_FULL_STATE) 
