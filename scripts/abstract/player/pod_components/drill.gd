extends PodComponent
class_name Drill

var base_drill_speed: float

func _init(p_name: String, p_base_price: int, p_base_drill_speed: float):
	super(p_name, p_base_price)
	self.base_drill_speed = p_base_drill_speed
