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





var _init_x: float
var _init_y: float
func _ready() -> void:
	_init_x = position.x
	_init_y = position.y



## Handles puffing of the player whilst moving

enum PuffState {
	NOT_PUFFING,
	IDLE_PUFFING,
	MOVE_PUFFING
}

# When idling (no buttons pressed), puff animation cycles every 11 frames (in flash fps)
const IDLE_PUFF_OUT_FRAME_COUNT = 3
const IDLE_INHALE_FRAME_COUNT = 8

# When idling (no buttons pressed), puff animation cycles every 4 frames (in flash fps)
const MOVE_PUFF_OUT_FRAME_COUNT = 3
const MOVE_INHALE_FRAME_COUNT = 1

var _puff_state: PuffState
var _puff_tween: Tween = create_tween()

## Checks whether character model is currently in the given puff state
func is_puff_state(puff_state: PuffState) -> bool:
	return _puff_state == puff_state

## Starts puffing with in the given puff state. Ignores command if puff state is NOT_PUFFING
func start_puffing(puff_state: PuffState) -> void:
	if puff_state == PuffState.NOT_PUFFING:
		return
	_puff_state = puff_state
	_reset_and_start_puff_tween(puff_state)

## Stops puffing. Note that this does not do anything if puffing is already stopped.
func stop_puffing() -> void:
	_puff_state = PuffState.NOT_PUFFING
	_puff_tween.kill()
	position.y = _init_y

## Resets the tween and starts it. The tween will loop indefinitely until stopped (or restarted).
func _reset_and_start_puff_tween(puff_type: PuffState) -> void:
	# Resets tween
	_puff_tween.kill()
	_puff_tween = create_tween()
	_puff_tween.set_loops()
	
	var puff_out_time := 1.0 / Constants.FLASH_FPS
	var inhale_time := 1.0 / Constants.FLASH_FPS
	
	var post_puff_out_wait_time: float
	var post_inhale_wait_time: float
	if puff_type == PuffState.IDLE_PUFFING:
		post_puff_out_wait_time = (IDLE_PUFF_OUT_FRAME_COUNT - 1) / Constants.FLASH_FPS
		post_inhale_wait_time = (IDLE_INHALE_FRAME_COUNT - 1) / Constants.FLASH_FPS
	elif puff_type == PuffState.MOVE_PUFFING: # inhale time var will always be 0
		post_puff_out_wait_time = (MOVE_PUFF_OUT_FRAME_COUNT - 1) / Constants.FLASH_FPS
		post_inhale_wait_time = (MOVE_INHALE_FRAME_COUNT - 1) / Constants.FLASH_FPS
	
	# puff out
	_puff_tween.tween_property(self, "position:y", _init_y + 1.0, puff_out_time)
	# wait
	if post_puff_out_wait_time > 0.0:
		_puff_tween.tween_interval(post_puff_out_wait_time)
	# inhale
	_puff_tween.tween_property(self, "position:y", _init_y + 0.5, inhale_time)
	_puff_tween.tween_property(self, "position:y", _init_y + 0.0, inhale_time)
	# wait
	if post_inhale_wait_time > 0.0:
		_puff_tween.tween_interval(post_inhale_wait_time)





## Handles shaking of the player when digging

const DIG_DOWN_SHAKE_X = 1
const DIG_SIDE_SHAKE_Y = 1

var _shake_tween: Tween = create_tween()

func start_shaking(dig_direction: AbstractPlayer.DigDirection) -> void:
	_reset_and_start_shake_tween(dig_direction)

func stop_shaking() -> void:
	_shake_tween.kill()
	position.x = _init_x
	position.y = _init_y

func _reset_and_start_shake_tween(dig_direction: AbstractPlayer.DigDirection) -> void:
	# Resets tween
	_shake_tween.kill()
	_shake_tween = create_tween()
	_shake_tween.set_loops()
	
	var shake_interval := 1.0 / Constants.FLASH_FPS
	
	if dig_direction == AbstractPlayer.DigDirection.DOWN:
		if flip_h: # facing right, so start shaking to the right first (extremely minor detail)
			_shake_tween.tween_property(self, "position:x", _init_x + DIG_DOWN_SHAKE_X, 0.0)
			_shake_tween.tween_interval(shake_interval)
			_shake_tween.tween_property(self, "position:x", _init_x - DIG_DOWN_SHAKE_X, 0.0)
			_shake_tween.tween_interval(shake_interval)
		else: # facing right, so start shaking to the left first (extremely minor detail)
			_shake_tween.tween_property(self, "position:x", _init_x - DIG_DOWN_SHAKE_X, 0.0)
			_shake_tween.tween_interval(shake_interval)
			_shake_tween.tween_property(self, "position:x", _init_x + DIG_DOWN_SHAKE_X, 0.0)
			_shake_tween.tween_interval(shake_interval)
	elif dig_direction == AbstractPlayer.DigDirection.SIDE:
		_shake_tween.tween_property(self, "position:y", _init_y + DIG_SIDE_SHAKE_Y, 0.0)
		_shake_tween.tween_interval(shake_interval)
		_shake_tween.tween_property(self, "position:y", _init_y, 0.0)
		_shake_tween.tween_interval(shake_interval)
