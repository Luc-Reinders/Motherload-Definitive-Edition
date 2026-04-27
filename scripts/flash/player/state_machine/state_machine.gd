extends StateMachine
class_name StateMachinePlayerFlash

const MOVE_STATE := &"Move"
const FLIGHT_STATE := &"Flight"
const TURN_GROUND_STATE := &"TurnGround"
const TURN_FLIGHT_STATE := &"TurnFlight"
const EXTEND_ROTOR_SIDE_DRILL_STATE := &"ExtendRotorSideDrill"
const EXTEND_ROTOR_BOTTOM_DRILL_STATE := &"ExtendRotorBottomDrill"
const RETRACT_ROTOR_BOTTOM_DRILL_STATE := &"RetractRotorBottomDrill"
const RETRACT_ROTOR_SIDE_DRILL_STATE := &"RetractRotorSideDrill"
const RETRACT_SIDE_DRILL_STATE := &"RetractSideDrill"
const RETRACT_BOTTOM_DRILL_STATE := &"RetractBottomDrill"
const EXTEND_SIDE_DRILL_STATE := &"ExtendSideDrill"
const EXTEND_BOTTOM_DRILL_STATE := &"ExtendBottomDrill"
const DIG_DOWN_STATE := &"DigDown"
const DIG_SIDE_STATE := &"DigSide"

# Pass the player nodes to each state to avoid duplication
@onready var player: FlashPlayer = $"../../Player"
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	for state: PlayerState in states.values():
		state.player = player
		state.visuals = player.visuals
		state.anim_sprite = state.visuals.animated_sprite
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state
