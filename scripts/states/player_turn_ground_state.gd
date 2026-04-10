extends State
class_name PlayerTurnGroundState

@export var player : PlayerAbstract

func enter():
	player._turning = true
	player.animated_sprite.play("turn_ground")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if player.animated_sprite.animation == "turn_ground" and player.animated_sprite.frame > 0:
		player._turning = false
		transitioned.emit(self, "Move")
