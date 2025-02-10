extends ParentState_Wall
class_name FastWallSlideState

static func id() -> String: return "fast_wall_slide" #id
#this is the fast wall slide state, which is when the player is sliding on a wall while holding down to slide down faster

func enter():
	super() #parent enter
	player.wall_slide_speed = player.FAST_WALL_SLIDE_SPEED
	player.wall_friction = player.FAST_WALL_FRICTION

func physics_process(delta) -> void:
	if ground_check(): return #check if we are still on the ground
	if !wall_check(): return #check if we are still on the wall

	wall_slide(delta) #do wall slide

func on_down_release(_time_pressed:float) -> void:
	change_state(WallSlideState.id())
	return


	
