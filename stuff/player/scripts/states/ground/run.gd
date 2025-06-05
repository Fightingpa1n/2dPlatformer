extends ParentState_Grounded
class_name RunState

static func id() -> String: return "run" #id
#Running on the ground (it's pretty self explanatory)

func enter(): 
    super() #call the ground state enter function
    player.max_move_speed = player.RUN_SPEED #set the max move speed to run speed
    player.move_acceleration = player.RUN_ACCELERATION #set the move acceleration to run acceleration
    player.move_deceleration = player.RUN_DECELERATION #set the move deceleration to run deceleration

func physics_process(delta):
    if ground_check(): return #do the ground check (if state change occured return)

    move(delta) #move the player

    if (!InputManager.left.pressed and !InputManager.right.pressed): #if move input is realeased
        change_state(WalkState.id()) #change to walk state
        return

    elif (InputManager.left.pressed and InputManager.right.pressed): #if both left and right are pressed
        if player.velocity.x == 0: #to a point where they cancel each other out long enough for the player to stop moving we change to idle
            change_state(IdleState.id()) #change to idle state
            return
    
    if (player.velocity.x == 0): #if we stop at any point while running, change to walk
        change_state(WalkState.id()) #change to walk state
        return
    
    # apply_friction(delta) #apply friction to the player (ground defaults)

func on_crouch_press() -> void: #on crouch input
    print("entered crouch from run") #debug
    change_state(SlideState.id()) #change to crouch state
    return