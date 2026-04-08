extends State
class_name PlayerRetractSideDrillState

@export var player : PlayerAbstract

func enter():
	player.prepare_for_drilling_down()
	player.animated_sprite.play("retract_side_drill")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if player.animated_sprite.animation == "retract_side_drill" and player.animated_sprite.frame > 0:
		transitioned.emit(self, "ExtendBottomDrill")
