extends AscendState
class_name JumpState

static func id() -> String: return "jump" #id
#this is the jump state, which is when the player is moving upwards in the air it is different from jump

func enter():
    player.jump_time = 0 #reset jump time

func physics_process(delta):
    ledge_forgivness()
    if ceiling_hit(): return #check if the player is hitting the ceiling (if state change occured return)
    # wall_check()

    player.jump_time += delta #increment jump time

    if player.jump_time < player.MIN_JUMP_TIME: #if jump time is less than minimum jump time
        player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump

    move(delta)

    if Input.is_action_pressed("jump") and player.jump_time < player.MAX_JUMP_TIME: #if jump is pressed and jump time is less than max jump time
        player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump
    else:
        change_state(FallState.id()) #change to fall state
        return

func on_jump_press(): #since this is the jump state we override the on_jump_press function of air and ascend state to do nothing
    pass

func on_jump_release(_time_pressed:float): #when we release the jump button
    if player.total_velocity().y < 0: #if we are moving upwards
        change_state(AscendState.id()) #change to fall state
        return
    else: #if we are falling down
        change_state(FallState.id()) #change to fall state
        return
    

    


