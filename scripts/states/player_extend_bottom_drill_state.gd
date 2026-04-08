extends State
class_name PlayerExtendBottomDrillState

@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("extend_bottom_drill")

func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if animated_sprite.animation == "extend_bottom_drill" and animated_sprite.frame > 0:
		transitioned.emit(self, "DrillDown")
