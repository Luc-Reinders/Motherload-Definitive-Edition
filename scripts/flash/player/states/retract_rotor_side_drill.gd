extends State
class_name PlayerFlashRetractRotorSideDrillState

@export var animated_sprite : AnimatedSpritePlayerFlash

func enter():
	animated_sprite.play(AnimatedSpritePlayerFlash.RETRACT_ROTOR_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.RETRACT_ROTOR_SIDE_DRILL_ANIM):
		# TODO: Update when acceleration is implemented
		transitioned.emit(self, StateMachinePlayerFlash.MOVE_STATE)
