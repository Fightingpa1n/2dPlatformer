extends PlayerState
class_name ParentState_Air

#The Parentstate for any Air States meaning the way how physics work in the air is defined here

# func normal_process(delta): #TODO: clean up
#     if player.coyote_time_time > 0:
#         player.coyote_time_time -= delta


# func wall_check(): #TODO: clean up

#     if player.collision.is_touching_wall():
#         var wall_direction = player.collision.get_wall_direction()
#         #if moving away from wall, return. or in other words if the player velocity is not towards the wall, return
#         if sign(player.total_velocity().x) != wall_direction:
#             return
        
#         #instead of using left and right let's use the movevent verctor :D
#         if player.movement_velocity.x != 0 and player.movement_velocity.x != wall_direction:
#             player.change_state("walled")

func ground_check(): #function to check for ground and change state if needed
    if collision.is_touching_ground():
        change_state("idle")



# func double_jump():
#     if player.jump_counter < player.EXTRA_JUMPS:
#         player.jump_counter += 1
#         player.change_state("jump")


func on_jump(): #on jump input
    print("Jump!")
    # if player.coyote_time_time > 0:
    #     player.coyote_time_time = 0
    #     player.change_state("jump")
    #     return true
    # else:
    #     return false

#helper methods with default values for grounded states
func move(delta:float,
    max_speed:float = player.AIR_MOVE_SPEED,
    acceleration:float = player.AIR_MOVE_ACCELERATION,
    deceleration:float = player.AIR_MOVE_DECELERATION
) -> void:
    super(delta, max_speed, acceleration, deceleration) #call the move function from the parent state

func apply_friction(delta:float, deceleration:float=player.AIR_FRICTION) -> void: #apply friction to the player
    super(delta, deceleration) #call the apply friction function from the parent state