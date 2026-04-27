extends IdlePuffState
class_name InhaleFullState

# Lasts 16 frames
const DURATION = 16.0 / Constants.FLASH_FPS

var time := 0.0



func enter():
	visuals.position.y -= 0.5

func _process(delta: float) -> void:
	time += delta
	
	if time >= DURATION:
		transitioned.emit(self, IdlePuffStateMachine.PUFF_OUT_STATE)
