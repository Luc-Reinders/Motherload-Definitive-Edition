extends PlayerState
class_name PlayerFlashTurnGroundState

func enter():
	player.start_turning()
	anim_sprite.play(FlashPlayerAnimatedSprite.TURN_GROUND_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.TURN_GROUND_ANIM):
		player.finish_turning()
		transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
