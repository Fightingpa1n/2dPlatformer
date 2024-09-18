#states/walled.gd
extends ParentState_Wall
class_name State_Walled

func physics_process(delta) -> void:
    super(delta)
    #on the wall we slowly wanna slide down, but if either up or down is pressed we want to slide faster or slower
    var slide_speed = player.WALL_SLIDE_SPEED

    if Input.is_action_pressed("down"):
        slide_speed = player.WALL_SLIDE_SPEED_FAST
    elif Input.is_action_pressed("up"):
        slide_speed = player.WALL_SLIDE_SPEED_SLOW

    player.velocity.y = move_toward(player.velocity.y, slide_speed, player.WALL_SLIDE_ACCELERATION * delta)


func on_input_jump() -> void:
    #if we jump we wanna do a wall jump
    pass



func on_input_left_right(movement: float) -> void:
    #if we move away from the wall we want to leave this state
    #movement is float and wall_direction is int so we need to convert it
    var move_direction = -1 if movement < 0 else 1

    if move_direction != wall_direction:
        player.change_state("fall")

    
