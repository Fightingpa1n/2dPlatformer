extends FallState
class_name FastFallState

static func id() -> String: return "fast_fall" #id
#this is the fastfall groundpound thingy #TODO: I need to find a better name for this state

func physics_process(delta):
    
    if ground_check(): return #do the ground check (if state change occured return)
    
    if !InputManager.down.pressed: #if the player is not holding down
        change_state(FallState.id()) #change to fall state
        return
    
    apply_gravity(delta, player.FASTFALL_SPEED, player.FASTFALL_ACCELERATION) #apply fast fall gravity

    move(delta) #while falling we are allowed to move

    # wall_check()

    if player.total_velocity().y < 0:
        change_state(AscendState.id())
    



    