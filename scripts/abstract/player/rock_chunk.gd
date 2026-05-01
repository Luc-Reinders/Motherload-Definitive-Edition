extends Node2D
class_name Chunk

const COLOR_TRANSITION_DURATION = 7.0 / Constants.FLASH_FPS

enum ChunkType {
	ROCK,
	LAVA
}

var chunk_type: ChunkType

# AS velocities
var xVel: float
var yVel: float

@onready var sprite: Sprite2D = $Sprite
@onready var on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var textures: Array[Texture2D]



func _ready() -> void:
	# Select 1 of 8 random chunk textures
	sprite.texture = textures.pick_random()
	
	# TODO: Find out true masking color cuz this ain't it boss.
	sprite.modulate = Color(3.0,2.9, 0, 1.0)
	# Apply color shift to 
	var tween_color = create_tween()
	if chunk_type == ChunkType.ROCK:
		tween_color.tween_property(sprite, "modulate", Color.WHITE, COLOR_TRANSITION_DURATION)
	elif chunk_type == ChunkType.LAVA:
		# TODO: is this color accurate?
		tween_color.tween_property(sprite, "modulate", Color(3,0.2,0), COLOR_TRANSITION_DURATION)
	
	# Randomly scales the sprite
	# TODO: generalize this to use an RNG object
	var random_scale = randf_range(0, 1.25) + 0.25
	sprite.scale *= random_scale
	on_screen_notifier.scale *= random_scale
	
	# Generate random velocity
	xVel = randi_range(0, 19) - 10.0
	yVel = randi_range(0, 4) - 10.0



# Update physics based on game code with delta-time incorporated. For more info on how delta_f
# works, go read abstract player class _physics_process method stupid.
func _physics_process(delta: float) -> void:
	var delta_f: float = delta * Constants.FLASH_FPS
	
	global_position.x += xVel * delta_f
	global_position.y += yVel * delta_f
	rotation_degrees += xVel * 2 * delta_f
	yVel += delta_f



## Notifies when the chunk has gone offscreen, so we remove this node.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
