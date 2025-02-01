extends ParentState_Grounded
class_name CrouchState 

static var id = "crouch"
#Crouching on the ground (it's pretty self explanatory)

func physics_process(delta):
    if !ground_check(): return #do the ground check (if state change occured return)
    
    if !InputManager.crouch.pressed: #if the crouch key is released
        change_state(IdleState.id) #change to idle state
        return
    
    move(delta, player.CROUCH_SPEED, player.CROUCH_ACCELERATION, player.CROUCH_DECELERATION) #move the player

    apply_friction(delta) #apply friction to the player (ground defaults)

func on_crouch_release(_time_pressed:float) -> void: #on crouch input
    change_state(IdleState.id) #change to idle state
    return