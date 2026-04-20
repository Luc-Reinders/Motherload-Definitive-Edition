extends AnimatedSprite2D
class_name AnimatedSpritePlayerFlash

const DRILL_DOWN_ANIM := &"drill_down"
const DRILL_SIDE_ANIM := &"drill_side"
const EXTEND_BOTTOM_DRILL_ANIM := &"extend_bottom_drill"
const EXTEND_ROTOR_BOTTOM_DRILL_ANIM := &"extend_rotor_bottom_drill"
const EXTEND_ROTOR_SIDE_DRILL_ANIM := &"extend_rotor_side_drill"
const EXTEND_SIDE_DRILL_ANIM := &"extend_side_drill"
const FLIGHT_ANIM := &"flight"
const MOVE_ANIM := &"move"
const RETRACT_BOTTOM_DRILL_ANIM := &"retract_bottom_drill"
const RETRACT_ROTOR_BOTTOM_DRILL_ANIM := &"retract_rotor_bottom_drill"
const RETRACT_ROTOR_SIDE_DRILL_ANIM := &"retract_rotor_side_drill"
const RETRACT_SIDE_DRILL_ANIM := &"retract_side_drill"
const TURN_FLIGHT_ANIM := &"turn_flight"
const TURN_GROUND_ANIM := &"turn_ground"

## This method is a hacky workaround for a race condition problem. Sometimes a signal from the
## animated sprite reaches multiple other nodes, and the order in which the signal reaches these 
## nodes is indeterminate due to race conditions. 
## An example of a problem that this causes is in the state machine. Let A, B and C be states such
## that state A transitiones to B, and B transitiones to C when the animation played during the
## respective state has finished (and each animation is played immediately upon entry). When A is
## finished, a signal is sent to all states listening to the animation finish signal. If we are 
## "unlucky", B receives the signal later than A. This means B becomes the new state first, and then
## B will receive the signal, and make C the new state without having played its animation (from
## its perspective its animation has just finished). 
func strong_finish_check(anim: StringName) -> bool:
	if animation != anim:
		return false
	return frame == sprite_frames.get_frame_count(anim) - 1
