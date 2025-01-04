#states/fastfall.gd
extends State_Fall
class_name State_FastFall

#this is the fastfall groundpound thingy idk I really need a better name

func physics_process(delta):
    if not Input.is_action_pressed("down"):
        player.change_state("fall")
        return
    
    player.velocity.y = move_toward(player.velocity.y, player.FASTFALL_SPEED, player.FASTFALL_ACCELERATION * delta)

    move(delta) #while falling we are allowed to move
    ground_check()
    wall_check()

    if player.total_velocity().y < 0:
        player.change_state("ascend")
    



    