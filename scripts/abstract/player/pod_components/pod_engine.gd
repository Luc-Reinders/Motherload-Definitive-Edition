extends PodComponent
class_name PodEngine

var base_power: int

func _init(p_name: String, p_base_price: int, p_base_power: int):
	super(p_name, p_base_price)
	self.base_power = p_base_power
