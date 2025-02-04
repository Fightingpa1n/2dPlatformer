extends ParentState_Grounded
class_name CrouchState 

static func id() -> String: return "crouch" #id
#Crouching on the ground (it's pretty self explanatory)

func enter():
    super() #call the ground state enter function
    player.max_move_speed = player.CROUCH_SPEED #set the max move speed to crouch speed
    player.move_acceleration = player.CROUCH_ACCELERATION #set the move acceleration to crouch acceleration
    player.move_deceleration = player.CROUCH_DECELERATION #set the move deceleration to crouch deceleration

func physics_process(delta):
    if !ground_check(): return #do the ground check (if state change occured return)
    
    if !InputManager.crouch.pressed: #if the crouch key is released
        change_state(IdleState.id()) #change to idle state
        return
    
    move(delta) #move the player

    apply_friction(delta) #apply friction to the player (ground defaults)

func on_crouch_release(_time_pressed:float) -> void: #on crouch input
    change_state(IdleState.id()) #change to idle state
    return