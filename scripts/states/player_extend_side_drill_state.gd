extends State
class_name PlayerExtendSideDrillState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("extend_side_drill")
	
func exit():
	pass


func _on_animated_sprite_animation_finished() -> void:
	if animated_sprite.animation == "extend_side_drill" and animated_sprite.frame > 0:
		var right = Input.is_action_pressed("move_right")
		var left = Input.is_action_pressed("move_left")
		
		if right or left:
			transitioned.emit(self, "Move")
		else:
			transitioned.emit(self, "Idle")
			
