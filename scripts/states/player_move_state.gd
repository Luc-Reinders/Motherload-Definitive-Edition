extends State
class_name PlayerMoveState

@export var player : PlayerAbstract

func enter():
	player.animated_sprite.play("move")
	
func exit():
	pass

func update(_delta):
	var right = Input.is_action_pressed("move_right")
	var left = Input.is_action_pressed("move_left")
	var up = Input.is_action_pressed("move_up")
	var down = Input.is_action_pressed("move_down")
	
	# Update animation speed depending on x velocity. This formula is based on the decompiled
	# code from flash Motherload.
	player.animated_sprite.speed_scale = (4.0 * player.velocity.x) / 5.0
	
	if up:
		go_to_state("ExtendPropellerSideDrill")
	elif down: # TODO: Movement speed need to be slow before you are allowed to drill down
		go_to_state("RetractSideDrill")
	elif right:
		if not player.is_facing_right() and player.velocity.x > 0: 
			# Turn right
			player.face_right()
			go_to_state("TurnGround")
		elif player.is_on_wall() and player.is_on_floor():
			go_to_state("DrillSide")
	elif left:
		if player.is_facing_right() and player.velocity.x < 0:
			# Turn left
			player.face_left()
			go_to_state("TurnGround")
		elif player.is_on_wall() and player.is_on_floor(): 
			go_to_state("DrillSide")
	elif player.velocity.x == 0:
		go_to_state("Idle")


func go_to_state(state_name: String):
	player.animated_sprite.speed_scale = 1
	transitioned.emit(self, state_name)
