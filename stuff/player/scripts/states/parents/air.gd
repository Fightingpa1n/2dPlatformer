#states/parents/air.gd
extends GrandParentState
class_name ParentState_Air

#The Parentstate for any Air States meaning the way how physics work in the air is defined here

func normal_process(delta):
    if player.coyote_time_time > 0:
        player.coyote_time_time -= delta


func wall_check():

    if player.collision.is_touching_wall():
        var wall_direction = player.collision.get_wall_direction()
        #if moving away from wall, return. or in other words if the player velocity is not towards the wall, return
        if sign(player.whole_velocity().x) != wall_direction:
            return
        
        #instead of using left and right let's use the movevent verctor :D
        if player.movement_velocity.x != 0 and player.movement_velocity.x != wall_direction:
            player.change_state("walled")

func ground_check(): #a recyclable function for checking the ground
    if player.collision.is_touching_ground():
        player.change_state("idle")
        return true
    else:
        return false


func move(delta): #a recyclable function for moving the player in the air
    var movement_direction = Input.get_axis("left", "right")

    if movement_direction != 0:
        player.movement_velocity.x = move_toward(player.movement_velocity.x, movement_direction * player.AIR_MOVE_SPEED, player.AIR_MOVE_ACCELERATION * delta)
    else:
        physics_movement_deceleration(player.AIR_MOVE_DECELERATION, delta)

    physics_deceleration(player.AIR_DECELERATION, delta) #deceleration for the player



func double_jump():
    if player.jump_counter < player.EXTRA_JUMPS:
        player.jump_counter += 1
        player.change_state("jump")


func on_input_jump():
    if player.coyote_time_time > 0:
        player.coyote_time_time = 0
        player.change_state("jump")
        return true
    else:
        return false