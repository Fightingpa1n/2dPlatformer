extends ParentState_Grounded
class_name WalkState

static func id() -> String: return "walk" #id
#Walking on the ground (it's pretty self explanatory)

func physics_process(delta):
    if !ground_check(): return #do the ground check (if state change occured return)

    if !InputManager.left.pressed and !InputManager.right.pressed: #if no input is pressed
        if player.total_velocity().x == 0: #once we stoped after no input
            change_state(IdleState.id()) #change to idle state
            return
    
    move(delta) #move the player (ground defaults)
    
    apply_friction(delta) #apply friction to the player (ground defaults)

func on_left_doubletap(): change_state(RunState.id()) #change to run on double tap
func on_right_doubletap(): change_state(RunState.id()) #change to run on double tap
    

