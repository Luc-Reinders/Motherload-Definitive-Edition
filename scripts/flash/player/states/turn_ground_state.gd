extends State
class_name PlayerFlashTurnGroundState

@export var player : PlayerFlash

func enter():
	player.start_turning()
	player.animated_sprite.play(AnimatedSpritePlayerFlash.TURN_GROUND_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if player.animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.TURN_GROUND_ANIM):
		player.finish_turning()
		transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
