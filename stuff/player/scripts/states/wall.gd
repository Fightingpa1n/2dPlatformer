extends PlayerState
class_name ParentState_Wall

#normally parent states are here to provide a common interface for their children but wallled is a bit of a special case #Future me: idk what that means? #cleanup me here: I still have no idea what that means
func enter() -> void: #on enter set global vars to wall values
	if player.current_wall_direction == 0: #if wall direction is not set
		change_state(FallState.id()) #change to fall state
		return
	
	player.movement_velocity.x = player.current_wall_direction * 1000 #add velocity towards the wall (this is my bad attempt to solve the wallstate midair bug)

	#reset stuff #TODO: I need to re-add this? I like the idea of it being only reset if a value is set.
	# if player.RESET_JUMP_COUNTER_ON_WALL:
		# player.jump_counter = 0

	player.wall_slide_speed = player.WALL_SLIDE_SPEED
	player.wall_friction = player.WALL_FRICTION
	
	#TODO: add Wall jump buffering #note: what?

func ground_check() -> bool: ## check if the player is still not touching ground returns true if a state change has occured 
	if collision.is_touching_ground():
		player.current_wall_direction = 0 #reset wall direction
		change_state(IdleState.id())
		return true
	else: return false

func wall_check() -> bool: ## check if player is still touching wall returns false if a state change has occured
	if collision.get_wall_direction() == 0: #if we are not touching a wall
		player.current_wall_direction = 0 #reset wall direction
		change_state(FallState.id())
		return false
	else: return true

func on_jump_press() -> void: #jump while on wall -> wall jump
	print("Wall Jump")
	# if player.WALL_JUMP and (player.jump_counter < player.JUMP_AMOUNT): #if wall jump is enabled and we have jumps left
	# 	var wall_jump_direction = Vector2(-wall_direction, -1) #get the wall jump direction
	# 	player.velocity = wall_jump_direction * player.WALL_JUMP_FORCE #set the velocity to the wall jump direction times the wall jump force
	# 	change_state(JumpState.id()) #change to jump state
	# else: #if no walljump available do wall flop (bad wall jump)
	# 	var wall_jump_direction = Vector2(-wall_direction, 0) #straight away from the wall (no height)
	# 	player.velocity = wall_jump_direction * player.WALL_FLOP_FORCE #set the velocity to the wall jump direction times the wall jump force
	# 	change_state(FallState.id()) #change to fall state

func on_horizontal_direction(direction: float) -> void:
	if direction != 0 and sign(direction) != player.current_wall_direction: #if we are moving away from the wall change state
		player.current_wall_direction = 0 #reset wall direction
		change_state(FallState.id())
		return

func on_vertical_direction(direction:float) -> void:
	if direction == 1:
		change_state(WalledState.id())
		return
	if direction == -1:
		change_state(FastWallSlideState.id())
		return
	return
