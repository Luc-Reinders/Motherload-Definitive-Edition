extends Node2D
class_name SteamParticle

@onready var pivot: Node2D = $Pivot
@onready var animated_sprite: AnimatedSprite2D = $Pivot/AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("puff")
	animated_sprite.connect("animation_finished", _on_finished)

func _on_finished():
	queue_free()
