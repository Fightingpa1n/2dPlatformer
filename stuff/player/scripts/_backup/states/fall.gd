#states/fall.gd
extends ParentState_Air
class_name State_Fall

#the fall state is the state where the player is in the air and falling down aka a positive y velocity, I think.
func enter():
    player.collision.change_enabled_jump_buffer(true)

func exit():
    player.collision.change_enabled_jump_buffer(false)

func physics_process(delta):
    wall_check()
    if Input.is_action_pressed("down"):
        player.change_state("fast_fall")
        return
    
    player.velocity.y = move_toward(player.velocity.y, player.FALL_SPEED, player.FALL_ACCELERATION * delta)

    move(delta) #while falling we are allowed to move
    ground_check()

    if player.whole_velocity().y < 0:
        player.change_state("ascend")

func on_input_jump():
    if super():
        return
    player.collision.jump_buffer_update_length()
    if player.collision.did_jump_buffer_hit():

        #do some ground check here to see if stuff is save to land on 
        var save_to_land = true #for the moment we can do it manually since there is no danger yet.

        if save_to_land:
            player.buffer_jump = true
            print("buffered jump")
            return
            
    double_jump()

