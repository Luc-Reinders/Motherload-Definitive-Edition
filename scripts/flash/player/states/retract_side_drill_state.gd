extends State
class_name PlayerFlashRetractSideDrillState

@export var player : PlayerFlash

func enter():
	player._preparing_digging_down = true
	player.animated_sprite.play(AnimatedSpritePlayerFlash.RETRACT_SIDE_DRILL_ANIM)

func _on_animated_sprite_animation_finished() -> void:
	if player.animated_sprite.strong_finish_check(AnimatedSpritePlayerFlash.RETRACT_SIDE_DRILL_ANIM):
		transitioned.emit(self, StateMachinePlayerFlash.EXTEND_BOTTOM_DRILL_STATE)
