extends CharacterBody2D
class_name PlayerAbstract

enum DrillDirection {
	SIDE,
	DOWN
}

# Nodes in the player class
@export var animated_sprite : AnimatedSprite2D
@export var collision_shape : CollisionShape2D
@export var state_machine: StateMachine
# Not in player class itself, but very useful for helper functions
@export var earth : EarthAbstract 

# Pod mass and component variables
@export var pod_mass: int
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

# Other variables
var steam_count: int = 0 # Represents rate of steam particles that need to be emitted
var rotor_speed: float = 0 # Used in the animation speed of the flying animation

# digging logic variables
var _digging: bool = false
var _digging_direction: DrillDirection
var _digging_velocity: float
var _digging_target_cell: Vector2i
var _digging_target_global_pos: Vector2
# digging downwards logic variables
var _preparing_digging_down: bool = false
var _digging_initial_target_diff: Vector2
var _digging_x_align_velocity: float

func is_digging() -> bool:
	return _digging



var _turning: bool = false

func is_turning() -> bool:
	return _turning

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



func calculate_weight() -> int:
	push_error("calculate_weight() must be overridden!")
	return -1
func calculate_bay_space() -> int:
	push_error("calculate_bay_space() must be overridden!")
	return -1
func get_depth() -> float:
	push_error("calculate_bay_space() must be overridden!")
	return -1



func start_digging(drill_direction: DrillDirection) -> void:
	# Set global player variables
	_digging = true
	_digging_direction = drill_direction
	_digging_velocity = calculate_digging_velocity(get_depth(), drill.base_drill_speed)
	
	var target_cell: Vector2i
	if drill_direction == DrillDirection.DOWN:
		target_cell = get_cell_below()
	elif drill_direction == DrillDirection.SIDE: 
		target_cell = get_cell_side()
	
	# Set global player variable
	_digging_target_cell = target_cell
	_digging_target_global_pos = earth.to_global(earth.map_to_local(target_cell))
	_digging_initial_target_diff = _digging_target_global_pos - global_position
	
	if drill_direction == DrillDirection.DOWN:
		_digging_x_align_velocity = float(_digging_initial_target_diff.x) / (50.0 * _digging_velocity)
	
	# Disable collisions so player can move through ground
	collision_shape.disabled = true 
	
	# Setting global player variables specifically for digging down
	if drill_direction == DrillDirection.DOWN:
		_preparing_digging_down = false

## Calculating (Godot) digging velocity using the code from Motherload.
func calculate_digging_velocity(depth: float, drill_base_speed: float) -> float:
	return ((0.5 * drill_base_speed) / (1.0 - (depth / 1000.0))) * Constants.FLASH_FPS

func finish_digging() -> void:
	# Re-enable collisions after player is done digging
	collision_shape.disabled = false 
	
	_digging = false
	
	# Erase tile and update cave textures
	earth.set_cell(_digging_target_cell, -1)
	earth.set_appropriate_cave_textures_3x3(_digging_target_cell)
	
	# Reset velocity
	velocity = Vector2.ZERO





func _physics_process(delta: float) -> void:
	if _digging:
		_physics_process_digging(delta)
	else:
		_physics_process_move(delta)

func _physics_process_digging(_delta: float) -> void:
	push_error("_physics_process_digging needs to be overridden!")

func _physics_process_move(_delta: float) -> void:
	push_error("_physics_process_move needs to be overridden!")





# digging debugging
func _process(_delta: float):
	queue_redraw()
func _draw():
	if _digging:
		draw_circle(to_local(_digging_target_global_pos), 5.0, Color.RED)
