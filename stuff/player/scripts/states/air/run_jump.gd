extends JumpState
class_name RunJumpState #TODO

#this is the run jump state, I know the name is a bit dumb but bassically imagine the longjump from mario 64, this state is a jump which focuses more on the horizontal movement than the vertical movement

static func id() -> String: return "run_jump" #id

func enter():
    super() #call the jump state enter function
    player.max_move_speed = player.RUN_SPEED