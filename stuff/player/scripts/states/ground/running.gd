extends ParentState_Grounded
class_name RunState

static var id = "run"
#Running on the ground (it's pretty self explanatory)

func physics_process(delta):
    ground_check() #do the ground check

    if player.total_velocity().x == 0: #if we have any velocity on the x axis we are nolonger standing still so let's change to walk
        change_state(IdleState.id)

    if !InputManager.run.pressed: #if run key is released
        change_state(WalkState.id) #change to walking

    move(delta, player.RUN_SPEED, player.RUN_ACCELERATION, player.RUN_DECELERATION) #move the player
    
    apply_friction(delta) #apply friction to the player (ground defaults)

func on_crouch_press() -> void: #on crouch input
    print("entered crouch from run") #debug
    change_state(CrouchState.id) #change to crouch state