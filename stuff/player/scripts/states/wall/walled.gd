extends ParentState_Wall
class_name WalledState

static func id() -> String: return "walled" #id
#this is the state when the player is on a wall, and holding up, either slowing the sliding down. or stopped completely

func enter():
	super() #parent enter
	player.wall_slide_speed = player.WALLED_SLIDE_SPEED
	player.wall_friction = player.WALLED_FRICTION


func physics_process(delta) -> void:
	if ground_check(): return #check if we are still on the ground
	if !wall_check(): return #check if we are still on the wall

	wall_slide(delta) #do wall slide



func on_up_release(_time_pressed:float) -> void:
	change_state(WallSlideState.id())
	return