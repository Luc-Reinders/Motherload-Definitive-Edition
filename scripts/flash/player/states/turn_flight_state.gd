extends State
class_name PlayerFlashTurnFlightState

@export var player : PlayerFlash

func enter():
	player.start_turning()
	player.animated_sprite.play(AnimatedSpritePlayerFlash.TURN_FLIGHT_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if player.animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.TURN_FLIGHT_ANIM):
		player.finish_turning()
		transitioned.emit(self, StateMachinePlayerFlash.FLIGHT_STATE)
	
