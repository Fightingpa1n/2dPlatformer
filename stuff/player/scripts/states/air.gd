extends PlayerState
class_name ParentState_Air

#The Parentstate for any Air States meaning the way how physics work in the air is defined here

func enter(): #on enter set global vars to air values
    player.max_move_speed = player.AIR_SPEED
    player.move_acceleration = player.AIR_ACCELERATION
    player.move_deceleration = player.AIR_DECELERATION
    player.friction = player.AIR_FRICTION
    if !player.released_jump: player.gravity = player.GRAVITY #reset gravity if released jump is false

func normal_process(delta):
    if player.coyote_timer > 0: #if the coyote timer is still active
        player.coyote_timer = max(0, player.coyote_timer - delta) #decrement the coyote timer (but fancy as to not go below 0)
    
    if player.buffer_timer > 0: #if the buffer timer is still active
        player.buffer_timer = max(0, player.buffer_timer - delta) #decrement the buffer timer (but fancy as to not go below 0)
        if player.buffer_timer == 0: #if the buffer timer is 0
            player.buffer_jump = false #reset the buffer jump

func wall_check() -> bool: ##check if player is touching wall, returns true on state change #TODO
    # if player.total_velocity().y < 0: return false #if we are moving upwards we don't want to check for walls #TODO: temporary solution until I have wall run implemented
    # var wall_direction = collision.get_wall_direction()
    # if wall_direction != 0: #if we are touching a wall
    #     if not sign(InputManager.horizontal.value) == -wall_direction: #if we are not moving away from the wall
    #         player.current_wall_direction = wall_direction #set the current wall direction
    #         change_state(WallSlideState.id()) #change to wall slide state
    #         return true
    return false

func ground_check() -> bool: ##check if the player is still on the ground returns true if a state change has occured 
    if collision.is_touching_ground():
        change_state(IdleState.id())
        return true
    return false

func physics_process(delta):
    if player.released_jump: #if gravity is still altered by jump realease
        if player.veloctiy.y >= 0: #if we stoped moving upwards or are moving downwards
            player.gravity = player.GRAVITY #reset gravity
            player.released_jump = false #reset released jump
    
    apply_gravity(delta) #apply gravity


func coyote_jump() -> bool: ## try do do coyote jump and return true on state change
    if player.coyote_timer > 0 and player.jump_counter < player.JUMP_AMOUNT: #if the coyote timer is still active
        change_state(JumpState.id()) #change to jump state
        return true
    else: return false

func air_jump() -> bool: ## try do do air jump and return true on state change
    if player.jump_counter < player.JUMP_AMOUNT: #if we have jumps left
        change_state(JumpState.id()) #change to jump state
        return true
    else: return false

func on_jump_press(): #on jump input
    if coyote_jump(): return #coyote jump
    if air_jump(): return #air jump

func on_horizontal_direction(direction: float) -> void: #on horizontal input
    var wall_direction = collision.get_wall_proximity_direction() #check if we are in proximity of a wall
    if direction != 0 and wall_direction != 0: #if we are moving and there is a wall in proximity
        if sign(direction) == wall_direction: #if we are moving towards the wall
            player.current_wall_direction = wall_direction #set the current wall direction
            change_state(WallEnterState.id()) #change to wall enter state
            return