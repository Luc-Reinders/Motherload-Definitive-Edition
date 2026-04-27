extends PlayerState
class_name PlayerFlashTurnFlightState

func enter():
	player.start_turning()
	anim_sprite.play(FlashPlayerAnimatedSprite.TURN_FLIGHT_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if anim_sprite.strong_finish_check(FlashPlayerAnimatedSprite.TURN_FLIGHT_ANIM):
		player.finish_turning()
		transitioned.emit(self, StateMachinePlayerFlash.FLIGHT_STATE)
	
