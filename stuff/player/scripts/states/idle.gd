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
