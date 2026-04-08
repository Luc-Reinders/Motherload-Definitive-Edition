extends State
class_name PlayerTurnGroundState

@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("turn_ground")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if animated_sprite.animation == "turn_ground" and animated_sprite.frame > 0:
		transitioned.emit(self, "Move")
