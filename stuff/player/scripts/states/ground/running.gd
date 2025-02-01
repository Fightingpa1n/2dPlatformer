extends ParentState_Grounded
class_name RunState

static var id = "run"
#Running on the ground (it's pretty self explanatory)

func physics_process(delta):
    if !ground_check(): return #do the ground check (if state change occured return)

    move(delta, player.RUN_SPEED, player.RUN_ACCELERATION, player.RUN_DECELERATION) #move the player

    if (!InputManager.left.pressed and !InputManager.right.pressed): #if move input is realeased
        change_state(WalkState.id) #change to walk state
        return

    elif (InputManager.left.pressed and InputManager.right.pressed): #if both left and right are pressed
        if player.total_velocity().x == 0: #to a point where they cancel each other out long enough for the player to stop moving we change to idle
            change_state(IdleState.id) #change to idle state
            return
    
    if (player.total_velocity().x == 0): #if we stop at any point while running, change to walk
        change_state(WalkState.id) #change to walk state
        return
    
    apply_friction(delta) #apply friction to the player (ground defaults)

func on_crouch_press() -> void: #on crouch input
    print("entered crouch from run") #debug
    change_state(SlideState.id) #change to crouch state
    return