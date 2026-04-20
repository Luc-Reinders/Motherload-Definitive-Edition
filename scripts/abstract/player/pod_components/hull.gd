extends PodComponent
class_name Hull

var base_health: int

func _init(p_name: String, p_base_price: int, p_base_health: int):
	super(p_name, p_base_price)
	self.base_health = p_base_health
