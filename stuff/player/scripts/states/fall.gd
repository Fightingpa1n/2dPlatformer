#states/fall.gd
extends ParentState_Air
class_name State_Fall

#the fall state is the state where the player is in the air and falling down aka a positive y velocity, I think.

func enter():
    collision.toggle_jump_buffer_ray(true) #enable jump buffer ray

func exit():
    collision.toggle_jump_buffer_ray(false) #disable jump buffer ray

func physics_process(delta):
    wall_check()
    if Input.is_action_pressed("down"):
        player.change_state("fast_fall")
        return
    
    player.velocity.y = move_toward(player.velocity.y, player.FALL_SPEED, player.FALL_ACCELERATION * delta)

    move(delta) #while falling we are allowed to move
    ground_check()

    if player.total_velocity().y < 0:
        player.change_state("ascend")

func on_input_jump():
    if super(): return #cyote jump check from parent

    var new_length = player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH + player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER * player.total_velocity().y #calculate lenght based on velocity
    collision.jump_buffer_update_length(new_length) #update the length of the jump buffer ray
    if player.collision.did_jump_buffer_hit():

        #do some ground check here to see if stuff is save to land on 
        var save_to_land = true #for the moment we can do it manually since there is no danger yet.

        if save_to_land:
            player.buffer_jump = true
            print("buffered jump")
            return
                
    double_jump()


    #NOTE: so if the raycasts hits and it would activate bufferjump but then the player moves to the side avoiding the ground that got hit by the raycast, the bufferjump will still be activated meaning the player will jump as soon as he hits the ground again which is not good since it feels horrible