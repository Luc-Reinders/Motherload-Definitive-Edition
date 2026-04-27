extends PlayerState
class_name PlayerFlashExtendBottomDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.EXTEND_BOTTOM_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.EXTEND_BOTTOM_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.DIG_DOWN_STATE)
