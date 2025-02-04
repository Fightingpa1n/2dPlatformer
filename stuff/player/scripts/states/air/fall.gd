extends ParentState_Air
class_name FallState

static func id() -> String: return "fall" #id
#while in the air whith a negative y velocity (aka. are falling down)

func enter():
    super() #call the air state enter function
    collision.toggle_jump_buffer_ray(true) #enable jump buffer ray

func exit():
    collision.toggle_jump_buffer_ray(false) #disable jump buffer ray

func physics_process(delta):
    #wall_check()
    if ground_check(): return #do the ground check (if state change occured return)
    # if player.total_velocity().y < 0:
    #     player.change_state("ascend")

    # if Input.is_action_pressed("down"):
    #     player.change_state("fast_fall")
    #     return
    
    apply_friction(delta) #apply friction to the player (air defaults)

    move(delta) #move the player (air defaults)

    apply_gravity(delta) #apply gravity to the player


func on_jump():
    pass
    # if super(): return #cyote jump check from parent

    # var new_length = player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH + player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER * player.total_velocity().y #calculate lenght based on velocity
    # collision.jump_buffer_update_length(new_length) #update the length of the jump buffer ray
    # if player.collision.did_jump_buffer_hit():

    #     #do some ground check here to see if stuff is save to land on 
    #     var save_to_land = true #for the moment we can do it manually since there is no danger yet.

    #     if save_to_land:
    #         player.buffer_jump = true
    #         print("buffered jump")
    #         return
                
    # double_jump()

    #TODO: if the raycasts hits and it would activate bufferjump but then the player moves to the side avoiding the ground that got hit by the raycast, the bufferjump will still be activated meaning the player will jump as soon as he hits the ground again which is not good since it feels horrible