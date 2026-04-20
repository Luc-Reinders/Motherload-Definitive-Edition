extends State
class_name PlayerFlashRetractRotorBottomDrillState

@export var animated_sprite : AnimatedSpritePlayerFlash

func enter():
	animated_sprite.play(AnimatedSpritePlayerFlash.RETRACT_ROTOR_BOTTOM_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.RETRACT_BOTTOM_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.DRILL_DOWN_STATE)
	
