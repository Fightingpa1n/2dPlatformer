extends ParentState_Wall
class_name WallSlideState

static func id() -> String: return "wall_slide" #id
#this is the wall slide state, which is when the player is on the wall with no special input sliding down with the normal speed¨

func enter():
	super() #parent enter
	player.wall_slide_speed = player.WALL_SLIDE_SPEED
	player.wall_friction = player.WALL_FRICTION

func physics_process(delta) -> void:
	if ground_check(): return #check if we are still on the ground
	if !wall_check(): return #check if we are still on the wall

	wall_slide(delta) #do wall slide


