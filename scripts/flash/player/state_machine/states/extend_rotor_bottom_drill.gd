extends PlayerState
class_name PlayerFlashExtendRotorBottomDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.EXTEND_ROTOR_BOTTOM_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.EXTEND_ROTOR_BOTTOM_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.FLIGHT_STATE)
