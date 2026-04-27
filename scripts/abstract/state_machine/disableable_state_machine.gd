extends StateMachine
class_name DisableableStateMachine

const DISABLED_STATE := &"DisabledState"

@export var disabled_state: DisabledState

func is_disabled() -> bool:
	return current_state == disabled_state

func enable() -> void:
	if is_disabled():
		var exit_state : DisableableState = disabled_state.exit_state
		disabled_state.transitioned.emit(disabled_state, exit_state.name)

func disable() -> void:
	if not is_disabled():
		var state_disableable: DisableableState = current_state
		state_disableable.on_disable()
		current_state.transitioned.emit(self, state_disableable.name)
