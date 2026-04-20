extends PodComponent
class_name Radiator

var base_cooling_factor: float

func _init(p_name: String, p_base_price: int, p_base_cooling_factor: float):
	super(p_name, p_base_price)
	self.base_cooling_factor = p_base_cooling_factor
