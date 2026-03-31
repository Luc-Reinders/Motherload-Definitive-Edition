extends State
class_name PlayerRetractPropellerSideDrillState

# DONE

@onready var animated_sprite : AnimatedSprite2D = $"../../AnimatedSprite"

func enter():
	animated_sprite.play("retract_propeller_side_drill")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if animated_sprite.animation == "retract_propeller_side_drill" and animated_sprite.frame > 0:
		# TODO: Update when acceleration is implemented
		
		var right = Input.is_action_pressed("move_right")
		var left = Input.is_action_pressed("move_left")
		
		if right or left:
			transitioned.emit(self, "Move")
		else:
			transitioned.emit(self, "Idle")
