#states/jump.gd
extends State_Ascend
class_name State_Jump

func enter():
    player.jump_time = 0 #reset jump time

func physics_process(delta):
    move(delta)
    ledge_forgivness()
    ceiling_hit()
    wall_check()

    player.jump_time += delta #increment jump time

    if player.jump_time < player.MIN_JUMP_TIME: #if jump time is less than minimum jump time
        player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump

    if Input.is_action_pressed("jump") and player.jump_time < player.MAX_JUMP_TIME: #if jump is pressed and jump time is less than max jump time
        player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump
    else:
        player.change_state("ascend")

func on_input_jump():
    pass #since this is the jump state we can overide the double /coyote jump stuff 