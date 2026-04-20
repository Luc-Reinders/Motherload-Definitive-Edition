extends RefCounted
class_name PodComponent

var name: String
var base_price: int # in dollar

func _init(p_name: String, p_base_price: int):
	self.name = p_name
	self.base_price = p_base_price
