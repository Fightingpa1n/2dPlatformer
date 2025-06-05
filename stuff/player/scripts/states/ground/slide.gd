extends ParentState_Grounded
class_name SlideState

static func id() -> String: return "slide" #id
#Sliding on the ground. like when running and then you enter crouching while running you will slide    

func enter():
	super() #call the ground state enter function
	player.friction = player.SLIDE_DECELERATION #set the move deceleration to slide deceleration

func physics_process(delta):
	if ground_check(): return #do the ground check (if state change occured return)
	
	if player.velocity.x == 0: #if we aren't moving we should be idle
		if InputManager.crouch.pressed:
			change_state(CrouchState.id()) #if the crouch key is still pressed change to crouch state
			return
		else:
			change_state(IdleState.id()) #if not change to idle state
			return

	apply_adjustable_friction(delta) #apply adjustable friction to the player
	
	# Apply slide deceleration
	# slow_down(delta)

	if !InputManager.crouch.pressed: #if the crouch key is released
		change_state(WalkState.id()) #change to walk state
		return

func on_crouch_release(_time_pressed:float) -> void: #on crouch input
	if player.velocity.x == 0: #if we aren't moving we should be idle
		change_state(IdleState.id()) #change to idle state
		return
	elif player.velocity.x >= player.RUN_SPEED: #if we are moving at run speed or faster
		change_state(RunState.id()) #change to run state
		return
	else:
		change_state(WalkState.id()) #change to walk state
		return
