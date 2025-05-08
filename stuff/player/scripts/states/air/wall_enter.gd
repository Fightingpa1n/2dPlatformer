extends ParentState_Air
class_name WallEnterState

#this is just a small state that is used inbetween an air state and a walled state when entering a wall over proximity, aka when there is still space between the player and the wall. (this state is just to move the player to the wall)

static func id() -> String: return "wall_enter" #id

func enter():
    if player.current_wall_direction == 0: #if wall direction is not set
        change_state(FallState.id()) #change to fall state
        return

    var wall_direction = collision.get_wall_direction() #get wall direction
    if wall_direction != 0 and player.current_wall_direction == wall_direction: #if we are now touching a wall and the wall direction is the same as the current wall direction
        change_state(WallSlideState.id()) #change to wall slide state
        return

func physics_process(_delta):
    var wall_direction = collision.get_wall_direction() #get wall direction
    if wall_direction != 0 and player.current_wall_direction == wall_direction: #if we are now touching a wall and the wall direction is the same as the current wall direction
        change_state(WallSlideState.id()) #change to wall slide state
        return

    player.movement_velocity.x = player.current_wall_direction * 1000 #add velocity towards the wall (this is my bad attempt to solve the wallstate midair bug)