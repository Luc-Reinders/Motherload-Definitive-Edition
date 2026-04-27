extends PlayerState
class_name PlayerFlashRetractRotorSideDrillState

func enter():
	anim_sprite.play(FlashPlayerAnimatedSprite.RETRACT_ROTOR_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.RETRACT_ROTOR_SIDE_DRILL_ANIM):
		# TODO: Update when acceleration is implemented
		transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
