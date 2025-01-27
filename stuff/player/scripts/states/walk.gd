extends ParentState_Grounded
class_name State_Walk

func physics_process(delta):
    ground_check() #do the ground check

    var movement_direction = InputManager.horizontal #get the horizontal input

    if movement_direction != 0:
        var max_speed = player.WALK_SPEED * movement_direction
        var acceleration = player.GROUND_MOVE_ACCELERATION * delta

        player.movement_velocity.x = move_toward(player.movement_velocity.x, max_speed, acceleration)
    else:
        slow_down(delta, player.GROUND_MOVE_DECELERATION) #apply friction to the player

    apply_friction(delta, player.GROUND_FRICTION) #apply friction to the player

    if player.total_velocity().x == 0:
        change_state("idle")
    

