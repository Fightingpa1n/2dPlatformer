#states/idle.gd
extends ParentState_Grounded
class_name State_Idle

#this is the idle state that bassically does nothing

func enter():
	super()

func physics_process(_delta):
	#since we are idle we are not moving.
	#so no need to check for movement
	#but we still need to do other stuff. stuff that isn't influenced by the player's input for example, 
	#like the ground suddenly disappearing and being set to freefall. or idk a Giant hammer knocking the player far away.
	ground_check()
	
	#but since I don't have any of this logic yet It's just empty for now.
	if abs(Input.get_axis("left", "right")) > 0:
		player.change_state("walk")


	

