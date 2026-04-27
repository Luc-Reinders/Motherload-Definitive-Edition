extends Node2D
class_name VisualsNode

@onready var idle_puff_state_machine: IdlePuffStateMachine = $IdlePuffStateMachine
@onready var animated_sprite: FlashPlayerAnimatedSprite = $AnimatedSprite

func is_idle_puffing() -> bool:
	return not idle_puff_state_machine.is_disabled()

## Starts idle puffing. It idle puffing was already started, command is ignored.
func start_idle_puffing() -> void:
	idle_puff_state_machine.enable()
## Stops idle puffing. It idle puffing was already stopped, command is ignored.
func stop_idle_puffing() -> void:
	idle_puff_state_machine.disable()
