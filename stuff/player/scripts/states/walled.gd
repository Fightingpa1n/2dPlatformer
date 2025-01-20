#states/walled.gd
extends ParentState_Wall
class_name State_Walled

func physics_process(delta) -> void:
	super(delta)
	#on the wall we slowly wanna slide down, but if either up or down is pressed we want to slide faster or slower
	var slide_speed = player.WALL_SLIDE_SPEED

	if Input.is_action_pressed("down"):
		slide_speed = player.WALL_SLIDE_SPEED_FAST
	elif Input.is_action_pressed("up"):
		slide_speed = player.WALL_SLIDE_SPEED_SLOW

	player.velocity.y = move_toward(player.velocity.y, slide_speed, player.WALL_SLIDE_ACCELERATION * delta)


func on_input_jump() -> void: #jump while on wall -> wall jump
	#change WALL_JUMP_DIRECTION Depending on the wall direction

	var wall_jump_direction = Vector2(-wall_direction, -1)

	#create a new Node(idk what would fit best maybe raycasr or jsut a normal shape) to display the direction ingame (for debugging)
	var direction_debug = RayCast2D.new()
	direction_debug.position = Vector2(0, 0)
	direction_debug.target_position = wall_jump_direction * player.WALL_JUMP_FORCE
	direction_debug.enabled = true
	player.add_child(direction_debug)




	# player.velocity = wall_jump_direction * player.WALL_JUMP_FORCE

func on_input_left_right(movement: float) -> void:
	#if we move away from the wall we want to leave this state
	#movement is float and wall_direction is int so we need to convert it
	var move_direction = -1 if movement < 0 else 1

	if move_direction != wall_direction:
		player.change_state("fall")

	
