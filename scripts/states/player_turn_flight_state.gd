extends State
class_name PlayerTurnFlightState

@export var player : PlayerAbstract

func enter():
	player._turning = true
	player.animated_sprite.play("turn_flight")
	
func exit():
	pass

func _on_animated_sprite_animation_finished() -> void:
	# animated_sprite.frame > 0 is hack to fix race condition on listener calls
	if player.animated_sprite.animation == "turn_flight" and player.animated_sprite.frame > 0 :
		player._turning = false
		transitioned.emit(self, "Flight")
	
