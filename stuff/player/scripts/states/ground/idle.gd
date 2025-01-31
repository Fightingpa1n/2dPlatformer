extends ParentState_Grounded
class_name IdleState

static var id = "idle"
#The Idle State acts as the default state for the Player, but also be the state the player is in while standing still

func physics_process(_delta):
	ground_check() #do the ground check

	if InputManager.left or InputManager.right: #if the player is pressing a direction key
		if InputManager.run: #if the player is not running
			change_state(RunState.id) #change to run state
		else: #if the player is running
			change_state(WalkState.id) #change to walk state
	
	elif abs(player.total_velocity().x) > 0: #if we have any velocity on the x axis we are nolonger standing still
		change_state(WalkState.id) #change to walk state


func on_horizontal(direction:float) -> void: #on horizontal input
	if direction != 0: #if the player is pressing a direction key
		change_state(WalkState.id) #change to walk state
    
