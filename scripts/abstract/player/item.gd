extends RefCounted
class_name Item

var name: String
var base_price: int

func _init(p_name: String, p_base_price: int):
	self.name = p_name
	self.base_price = p_base_price
