extends JumpState
class_name RunJumpState #TODO

static func id() -> String: return "run_jump" #id
#this is the run jump state, I know the name is a bit dumb but bassically imagine the longjump from mario 64, this state is a jump which focuses more on the horizontal movement than the vertical movement

var init_horizontal_velocity:float ## the inital run velocity of the player when entering the jump state from running

func enter():
    init_horizontal_velocity = player.total_velocity().x #set the initial horizontal velocity to the player's current horizontal velocity
    player.jump_time = 0 #reset jump time

func normal_process(delta):
    player.jump_time += delta #increment jump time

func physics_process(delta):
    if ceiling_hit(): return #check if the player is hitting the ceiling (if state change occured return)

    if player.jump_time < player.MIN_JUMP_TIME: #if jump time is less than minimum jump time
        player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump

    move(delta)

    if InputManager.jump.pressed and player.jump_time < player.MAX_JUMP_TIME: #if jump is pressed and jump time is less than max jump time
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


    


