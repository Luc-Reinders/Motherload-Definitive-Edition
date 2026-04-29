extends AnimatedSprite2D
class_name FlashPlayerAnimatedSprite

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
## "unlucky", B receives the signal later than A. This means B becomes the new state first, then
## B will receive the signal next, thus making C the new state without having played its animation 
## (from B's perspective, its animation just finished). 
func strong_finish_check(anim: StringName) -> bool:
	if animation != anim:
		return false
	return frame == sprite_frames.get_frame_count(anim) - 1





# TODO: Figure out how long between puffs
const FRAMES_BETWEEN_PUFFS := 3
const PUFF_FRAMES := 3 # number of puff frames

var _puffing: bool = false
var _time: float = 0.0
var _tween: Tween = create_tween()

var _init_y_offset: float
func _ready() -> void:
	_init_y_offset = position.y



func is_idle_puffing() -> bool:
	return _puffing

## Starts idle puffing on the character sprite. If the character was already
## puffing, the command is ignored.
func start_idle_puffing() -> void:
	pass
	if not _puffing:
		_puffing = true
		puff()

## Stops idle puffing on the character sprite. If the puffing was already
## stopped, the command is ignored.
func stop_idle_puffing() -> void:
	pass
	if _puffing:
		_puffing = false
		_time = 0.0
		_tween.kill() # Stops all tweening immediately
		position.y = _init_y_offset



func _process(delta: float) -> void:
	pass
	if _puffing:
		_time += delta
		if _time >= (FRAMES_BETWEEN_PUFFS + PUFF_FRAMES) / Constants.FLASH_FPS:
			puff()
			_time = 0.0

func puff():
	# Resets tween
	_tween.kill()
	_tween = create_tween()
	
	_tween.tween_property(self, "position:y", _init_y_offset + 1.0, 1.0/Constants.FLASH_FPS)
	_tween.tween_property(self, "position:y", _init_y_offset + 0.5, 1.0/Constants.FLASH_FPS)
	_tween.tween_property(self, "position:y", _init_y_offset + 0.0, 1.0/Constants.FLASH_FPS)
