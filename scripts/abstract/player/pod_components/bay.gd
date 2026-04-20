extends PodComponent
class_name Bay

var base_size: int

func _init(p_name: String, p_base_price: int, p_base_size: int):
	super(p_name, p_base_price)
	self.base_size = p_base_size
