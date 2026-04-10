extends CharacterBody2D
class_name PlayerAbstract

enum DrillDirection {
	SIDE,
	DOWN
}

# TODO: rename all propeller variables/animations to "rotor"

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var state_machine: StateMachine = $"State Machine"
@export var earth : EarthAbstract # TODO: Remove as export and make an argument in methods?

@export var pod_mass: int # Mass in Decakilograms (1980 kgs becomes 198)

# Pod component variables
var drill: Drill 
var hull: Hull
var engine: PodEngine
var fuel_tank: FuelTank
var radiator: Radiator
var bay: Bay

# Stats
var fuel: float
var health: float
var money: int
var bay_contents: Dictionary[Collectable, int] = {}
var items: Dictionary[Item, int] = {}

func calculate_weight() -> int:
	var w = pod_mass
	for collectable in bay_contents:
		w += bay_contents[collectable] * collectable.base_mass
	return w
func calculate_bay_space() -> int:
	var s = bay.base_size
	for collectable in bay_contents:
		s -= bay_contents[collectable]
	return s


# Other variables
var steam_count: int = 0 # Represents rate of steam particles that need to be emitted
var rotor_speed: float = 0 # Used in the animation speed of the flying animation

# Drilling logic variables
var _drilling: bool = false
var _drilling_direction: DrillDirection
var _drilling_target_cell: Vector2i
var _drilling_target_global_pos: Vector2
# Drilling downwards logic variables
var _preparing_drilling_down: bool = false
var _drilling_initial_target_diff: Vector2

func is_drilling() -> bool:
	return _drilling



var _turning: bool = false

func is_turning() -> bool:
	return _turning


## Returns whether the player is facing right. DOES NOT WORK WITH TURNING!
func is_facing_right() -> bool:
	return animated_sprite.flip_h
func face_right() -> void:
	animated_sprite.flip_h = true
func face_left() -> void:
	animated_sprite.flip_h = false
func flip_face() -> void:
	animated_sprite.flip_h = !animated_sprite.flip_h


# TODO: collaps get_cell methods into one general method?
func get_cell_below() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	# Cell is the player occupied cell, so look one cell below
	cell.y += 1
	return cell

## Gets the cell next to where the pod is looking
func get_cell_side() -> Vector2i:
	# Find local coordinate of player in the TileMapLayer
	var local_pos = earth.to_local(global_position) 
	# Find cell that the local coordinate is in
	var cell = earth.local_to_map(local_pos) 
	
	if is_facing_right(): 
		cell.x += 1
	else: # Looking left
		cell.x -= 1
	
	return cell



func prepare_for_drilling_down() -> void:
	_preparing_drilling_down = true

func start_drilling(drill_direction: DrillDirection) -> void:
	# Set global player variables
	_drilling = true
	_drilling_direction = drill_direction
	
	var target_cell: Vector2i
	if drill_direction == DrillDirection.DOWN:
		target_cell = get_cell_below()
	elif drill_direction == DrillDirection.SIDE: 
		target_cell = get_cell_side()
	
	# Set global player variable
	_drilling_target_cell = target_cell
	_drilling_target_global_pos = earth.to_global(earth.map_to_local(target_cell))
	_drilling_initial_target_diff = _drilling_target_global_pos - global_position
	
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 
	
	# Setting global player variables specifically for drilling down
	if drill_direction == DrillDirection.DOWN:
		_preparing_drilling_down = false
		
		

func finish_drilling() -> void:
	# Re-enable collisions after player is done drilling
	collision_shape.disabled = false 
	
	_drilling = false
	
	# Erase tile and update cave textures
	earth.set_cell(_drilling_target_cell, -1)
	earth.set_appropriate_cave_textures_3x3(_drilling_target_cell)
	
	# Reset velocity
	velocity = Vector2.ZERO



@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	push_error("Physics process needs to be overridden for movement!!!")







# Drilling debugging
@warning_ignore("unused_parameter")
func _process(delta: float):
	queue_redraw()
func _draw():
	if _drilling:
		draw_circle(to_local(_drilling_target_global_pos), 5.0, Color.RED)
