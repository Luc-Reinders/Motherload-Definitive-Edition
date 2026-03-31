extends State
class_name PlayerRetractSideDrillState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("retract_side_drill")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if animated_sprite.animation == "retract_side_drill" and animated_sprite.frame > 0:
		transitioned.emit(self, "ExtendBottomDrill")
