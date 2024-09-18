#states/idle.gd
extends ParentState_Ground
class_name State_Idle

# this is the state that the player is in when they are not doing anything

func physics_process(_delta):
	ground_check()

	if abs(Input.get_axis("left", "right")) > 0:
		player.change_state("walk")

	if abs(player.whole_velocity().x) > 0:
		player.change_state("walk")
	else: #TODO: THIs is really stupid, the reason why it's here is because for some reason the velocity and movement velocity are not 0 when running into a wall but they should be since we are in idle and idk why that is ? (it result in a magnetic feeling wall idk)
		player.velocity.x = 0
		player.movement_velocity.x = 0
		player.other_velocity.x = 0
    
