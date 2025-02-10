extends FallState
class_name FastFallState

static func id() -> String: return "fast_fall" #id
#this is the fastfall groundpound thingy #TODO: I need to find a better name for this state

func enter():
    super() #call the fall state enter function
    # player.gravity = 
    # player.max_fall_speed = 

func physics_process(delta):
    super(delta) #call the fall state physics process

    if !InputManager.down.pressed: #if the player is not holding down
        change_state(FallState.id()) #change to fall state
        return

func on_down_release(_time_pressed:float) -> void:
    change_state(FallState.id()) #change to fall state
    return



    