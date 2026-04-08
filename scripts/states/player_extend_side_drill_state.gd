extends State
class_name PlayerExtendSideDrillState

@export var animated_sprite : AnimatedSprite2D

func enter():
	animated_sprite.play("extend_side_drill")
	
func exit():
	pass


func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if animated_sprite.animation == "extend_side_drill" and animated_sprite.frame > 0:
		var right = Input.is_action_pressed("move_right")
		var left = Input.is_action_pressed("move_left")
		
		if right or left:
			transitioned.emit(self, "Move")
		else:
			transitioned.emit(self, "Idle")
			
