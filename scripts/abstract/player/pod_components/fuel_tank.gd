extends PodComponent
class_name FuelTank

var base_capacity: int

func _init(p_name: String, p_base_price: int, p_base_capacity: int):
	super(p_name, p_base_price)
	self.base_capacity = p_base_capacity
