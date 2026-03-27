extends State
class_name PlayerExtendBottomDrillState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("extend_bottom_drill")

func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "extend_bottom_drill" and animated_sprite.frame > 0:
		transitioned.emit(self, "DrillDown")
