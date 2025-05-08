extends ParentState_Wall
class_name WallRunState

#TODO: this is not implemented yet, since I don't know exactly how to handle this yet. for now, I will just not enter the wall states when moving up...
# the wall run state should be a wallstate for when the player has negative y velocity (aka. moving upwards) and is touching a wall.
#it should help him move up a bit faste as he is moving up the wall and incase he jumps in this state he should gain much more height than a regular walljump.
#this is instead of just entering the wallslide state when the player touches a wall nomather what. or just moving down. making him ignore walls on the way up. (idk I'm not good at explaining, but I hope it's clear enough)

static func id() -> String: return "wall_run" #id


func on_jump_press() -> void: #override the normal walljump #TODO
    print("Wall Jump from wall run")