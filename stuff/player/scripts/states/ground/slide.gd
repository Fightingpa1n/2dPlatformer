extends ParentState_Grounded
class_name SlideState

static var id = "slide"
#Sliding on the ground. like when running and then you enter crouching while running you will slide

func physics_process(delta):
    ground_check() #do the ground check
    
    if player.total_velocity().x == 0: #if we aren't moving we should be idle
        if InputManager.crouch: change_state(CrouchState.id) #if the crouch key is still pressed change to crouch state
        else: change_state(IdleState.id) #if not change to idle state
    
    if !InputManager.crouch: #if the crouch key is released
        change_state(WalkState.id) #change to walk state

    #TODO: figure out how to do slide physics