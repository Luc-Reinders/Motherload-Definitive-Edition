extends PlayerState
class_name PlayerFlashExtendSideDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.EXTEND_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.EXTEND_SIDE_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
			
