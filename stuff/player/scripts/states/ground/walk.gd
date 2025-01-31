extends ParentState_Grounded
class_name WalkState

static var id = "walk"
#Walking on the ground (it's pretty self explanatory)

func physics_process(delta):
    ground_check() #do the ground check

    if player.total_velocity().x == 0: #if we aren't moving we should be idle
        change_state(IdleState.id)
    
    if InputManager.run: #if the player is running
        change_state(RunState.id) #change to run state
    
    move(delta) #move the player (ground defaults)
    
    apply_friction(delta) #apply friction to the player (ground defaults)

func on_run() -> void: #on run input
    change_state(RunState.id) #change to run state
    

