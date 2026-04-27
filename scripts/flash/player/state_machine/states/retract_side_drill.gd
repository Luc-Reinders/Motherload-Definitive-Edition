extends PlayerState
class_name PlayerFlashRetractSideDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.RETRACT_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.RETRACT_SIDE_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.EXTEND_BOTTOM_DRILL_STATE)
