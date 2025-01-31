extends ParentState_Grounded
class_name CrouchState 

static var id = "crouch"
#Crouching on the ground (it's pretty self explanatory)

func physics_process(delta):
    ground_check() #do the ground check
    
    if !InputManager.crouch: #if the crouch key is released
        change_state(IdleState.id) #change to idle state
    
    move(delta, player.CROUCH_SPEED, player.CROUCH_ACCELERATION, player.CROUCH_DECELERATION) #move the player

    apply_friction(delta) #apply friction to the player (ground defaults)
