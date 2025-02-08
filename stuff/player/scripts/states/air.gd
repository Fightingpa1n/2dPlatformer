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


# func wall_check(): #TODO: clean up

#     if player.collision.is_touching_wall():
#         var wall_direction = player.collision.get_wall_direction()
#         #if moving away from wall, return. or in other words if the player velocity is not towards the wall, return
#         if sign(player.total_velocity().x) != wall_direction:
#             return
        
#         #instead of using left and right let's use the movevent verctor :D
#         if player.movement_velocity.x != 0 and player.movement_velocity.x != wall_direction:
#             player.change_state("walled")

func ground_check() -> bool: ## check if the player is still on the ground returns true if a state change has occured 
    if collision.is_touching_ground():
        change_state(IdleState.id())
        return true
    else: return false


func physics_process(delta):
    if player.released_jump: #if gravity is still altered by jump realease
        if player.total_velocity().y >= 0: #if we stoped moving upwards or are moving downwards
            player.gravity = player.GRAVITY #reset gravity
            player.released_jump = false #reset released jump
    
    apply_gravity(delta) #apply gravity
    apply_friction(delta) #apply friction


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

