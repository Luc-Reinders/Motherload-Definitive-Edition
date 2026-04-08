extends RefCounted
class_name Collectable

enum CollectableType {
	MINERAL,
	ARTIFACT
}

var name: String
var base_value: int # in dollars
var base_mass: int # in kilograms
var type: CollectableType

func _init(p_name: String, p_base_value: int, p_base_mass: int, p_type: CollectableType) -> void:
	self.type = p_type
	self.name = p_name
	self.base_value = p_base_value
	self.base_mass = p_base_mass 
