extends State
class_name PlayerFlashExtendRotorSideDrillState

@export var animated_sprite : AnimatedSpritePlayerFlash

func enter():
	animated_sprite.play(AnimatedSpritePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.EXTEND_ROTOR_SIDE_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.FLIGHT_STATE)
	
