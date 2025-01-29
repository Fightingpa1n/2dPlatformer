extends ParentState_Grounded
class_name State_Idle

# this is the state that the player is in when they are not doing anything

func physics_process(_delta):
	ground_check() #do the ground check

	if abs(player.total_velocity().x) > 0: #if we have any velocity on the x axis we are nolonger standing still so let's change to walk
		player.change_state("walk")

	if InputManager.left or InputManager.right: #if the player is pressing a direction key
		player.change_state("walk") #change to walk state
	
func on_horizontal(direction:float) -> void: #on horizontal input
	if direction != 0: #if the player is pressing a direction key
		player.change_state("walk") #change to walk state
    
