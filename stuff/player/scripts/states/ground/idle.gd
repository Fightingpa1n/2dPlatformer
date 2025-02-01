extends ParentState_Grounded
class_name IdleState

static var id = "idle"
#The Idle State acts as the default state for the Player, but also be the state the player is in while standing still

func physics_process(_delta):
	if !ground_check(): return #do the ground check (if state change occured return)

	if InputManager.left.pressed or InputManager.right.pressed: #if the player is pressing a direction key
		change_state(WalkState.id) #change to walk state
		return
	
	if abs(player.total_velocity().x) >= player.RUN_SPEED: #if we are moving at run speed or faster
		change_state(RunState.id) #change to run state
		return
	elif abs(player.total_velocity().x) > 0: #otherwise if we have any velocity on the x axis§
		change_state(WalkState.id) #change to walk state
		return
	

func on_horizontal_direction(direction:float) -> void: #on horizontal input
	if direction != 0: #if the player is pressing a direction key
		change_state(WalkState.id) #change to walk state
		return

func on_left_doubletap(): change_state(RunState.id) #change to run on double tap
func on_right_doubletap(): change_state(RunState.id) #change to run on double tap
