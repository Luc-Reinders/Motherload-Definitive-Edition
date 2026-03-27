extends State
class_name PlayerTurnGroundState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("turn_ground")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "turn_ground" and animated_sprite.frame > 0:
		transitioned.emit(self, "Move")
