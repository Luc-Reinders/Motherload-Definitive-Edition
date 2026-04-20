extends RefCounted
class_name Collectable

## Instead of an enum we use a class with constants. This is so we can modularly
## add more types later without compromising the abstractness of this class.
class Type:
	const MINERAL := "Mineral"
	const ARTIFACT := "Artifact"

var name: String
var base_value: int # in dollars
var base_mass: int # in kilograms
var type: String

func _init(p_name: String, p_base_value: int, p_base_mass: int, p_type: String) -> void:
	self.name = p_name
	self.base_value = p_base_value
	self.base_mass = p_base_mass 
	self.type = p_type
