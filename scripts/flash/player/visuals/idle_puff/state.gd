extends DisableableState
class_name IdlePuffState

@export var visuals: VisualsNode

func on_disable() -> void:
	visuals.position.y = 0.0
