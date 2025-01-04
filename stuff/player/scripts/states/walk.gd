#states/walk.gd
extends ParentState_Ground
class_name State_Walk

func physics_process(delta):
    ground_check()

    var movement_direction = Input.get_axis("left", "right")

    if movement_direction != 0:
        player.movement_velocity.x = move_toward(player.movement_velocity.x, movement_direction * player.WALK_SPEED, player.WALK_ACCELERATION * delta)
    else:
        physics_movement_deceleration(player.GROUND_DECELERATION, delta)
        
    physics_deceleration(player.GROUND_DECELERATION, delta) #general deceleration

    if player.total_velocity().x == 0:
        player.change_state("idle")
    

