extends PlayerState
class_name ParentState_Grounded

#The Parentstate for any Grounded States meaning the way how physics work on ground is defined here

func enter(): #on enter any grounded state should reset values like coyote time and jump counter
	pass #TODO: I don't reset values currently since I don't use them yet,
	# player.coyote_time_time = player.COYOTE_TIME
	# player.jump_counter = 0

	# if player.buffer_jump:
	# 	player.buffer_jump = false
	# 	print("jumped from the buffer")
	# 	player.change_state("jump")

func ground_check() -> bool: ## check if the player is still on the ground returns false if a state change has occured
	if !collision.is_touching_ground():
		change_state(FallState.id)
		return false
	else: return true

func on_jump_press(): #the jump init can be handled here since pretty much all grounded states won't need to alter it
	print("Jump!")
	#player.change_state("jump") #TODO: commented out for the moment since I need to clean up jump first and readd it to the state machine

func on_crouch_press(): #the crouch init can be handled here since pretty much all grounded states won't need to alter it
	change_state(CrouchState.id)
	return

#helper methods with default values for grounded states
func move(delta:float,
	max_speed:float = player.WALK_SPEED,
	acceleration:float = player.GROUND_MOVE_ACCELERATION,
	deceleration:float = player.GROUND_MOVE_DECELERATION
) -> void:
	super(delta, max_speed, acceleration, deceleration) #call the move function from the parent state

func apply_friction(delta:float, deceleration:float=player.GROUND_FRICTION) -> void: #apply friction to the player
	super(delta, deceleration) #call the apply friction function from the parent state