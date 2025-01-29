extends ParentState_Grounded
class_name State_Walk

func physics_process(delta):
    ground_check() #do the ground check

    if player.total_velocity().x == 0: #if we aren't moving we should be idle
        change_state("idle")

    move(delta) #move the player (ground defaults)

    apply_friction(delta) #apply friction to the player (ground defaults)

    

