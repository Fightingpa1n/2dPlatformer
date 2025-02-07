extends PlayerState
class_name ParentState_Grounded

#The Parentstate for any Grounded States meaning the way how physics work on ground is defined here

func enter(): #on enter any grounded state should reset values like coyote time and jump counter
	player.max_move_speed = player.WALK_SPEED
	player.move_acceleration = player.WALK_ACCELERATION
	player.move_deceleration = player.WALK_DECELERATION
	player.friction = player.GROUND_FRICTION
	
	player.coyote_timer = player.COYOTE_TIME #reset coyote timer
	player.buffer_timer = 0 #empty buffer timer
	player.jump_counter = 0 #reset jump counter

	if player.buffer_jump:
		player.buffer_jump = false
		if player.jump_counter < player.JUMP_AMOUNT: #if we have jumps left
			change_state(JumpState.id()) #jump
			return
	
func ground_check() -> bool: ## check if the player is still on the ground returns false if a state change has occured
	if !collision.is_touching_ground():
		change_state(FallState.id())
		return false
	else: return true

func on_jump_press(): #the jump init can be handled here since pretty much all grounded states won't need to alter it
	if player.jump_counter < player.JUMP_AMOUNT: #if we have jumps left
		change_state(JumpState.id())
		return

func on_crouch_press(): #the crouch init can be handled here since pretty much all grounded states won't need to alter it
	change_state(CrouchState.id())
	return