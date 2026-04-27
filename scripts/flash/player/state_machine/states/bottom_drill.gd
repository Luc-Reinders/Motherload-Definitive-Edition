extends PlayerState
class_name PlayerFlashRetractBottomDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.RETRACT_BOTTOM_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.RETRACT_BOTTOM_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.EXTEND_SIDE_DRILL_STATE)
