extends PlayerState
class_name ParentState_Wall

#normally parent states are here to provide a common interface for their children but wallled is a bit of a special case #Future me: idk what that means? #cleanup me here: I still have no idea what that means

var wall_direction:int
func get_wall_direction() -> int: return wall_direction ## returns the wall direction (aka which side the wall is on we are touching)

func enter():
    wall_direction = collision.get_wall_direction() #on enter, get wall direction
    player.velocity.x = 0
    player.movement_velocity.x = 0
    player.other_velocity.x = 0

    #reset stuff #TODO: I need to re-add this? I like the idea of it being only reset if a value is set.
    # if player.RESET_JUMP_COUNTER_ON_WALL:
        # player.jump_counter = 0

    player.wall_slide_speed = player.WALL_SLIDE_SPEED
    player.wall_friction = player.WALL_FRICTION
    
    #TODO: add Wall jump buffering #note: what?

func ground_check() -> bool: ## check if the player is still not touching ground returns true if a state change has occured 
    if collision.is_touching_ground():
        change_state(IdleState.id())
        return true
    else: return false

func wall_check() -> bool: ## check if player is still touching wall returns false if a state change has occured
    if !player.collision.is_touching_wall():
        change_state(FallState.id())
        return false
    else: return true

func on_jump_press() -> void: #jump while on wall -> wall jump
    print("Wall Jump")
    pass #TODO: implement wall jump
    # player.velocity = wall_jump_direction * player.WALL_JUMP_FORCE

func on_horizontal_direction(direction: float) -> void:
    var movement = sign(direction) #get the direction
    if movement != 0 and movement != wall_direction: #if we are moving away from the wall change state
        change_state(FallState.id())
        return

func on_vertical_direction(direction:float) -> void:
    if direction == 1:
        change_state(WalledState.id())
        return
    if direction == -1:
        change_state(FastWallSlideState.id())
        return
    return