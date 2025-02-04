extends AscendState
class_name JumpState

static func id() -> String: return "jump" #id
#this is the jump state, which is when the player is moving upwards in the air it is different from jump

func enter():
	player.jump_time = 0 #reset jump time

func physics_process(delta):
	ledge_forgivness()
	if ceiling_hit(): return #check if the player is hitting the ceiling (if state change occured return)
	# wall_check() #TODO: wall states are currently disabled
	
	move(delta)
	
	if InputManager.jump.pressed: #while Jump is still pressed #TODO: the jump feels kinda bad due to the fact we are applying the same force over a period of time, this makes it feel more like a jetpack than a jump which should be one massive force at the start and then holding just slows down the decrease of that initial force allowing one to jump higher
		if InputManager.jump.time_pressed <= player.MAX_JUMP_TIME: #if the time pressed is less than the max jump time
			player.velocity.y = -player.JUMP_FORCE #set velocity still in the initial jump
		else: #if the time pressed is more than the max jump time (aka no longer relevant)
			stop_jump() #stop jumping
			return
	
	else: #if jump is released
		stop_jump() #stop jumping
		return

func on_jump_press(): pass #override the on_jump_press of air states to do nothing

func on_jump_release(_time_pressed:float): #when we release the jump button
	stop_jump() #stop jumping
	return

func stop_jump(): ## a helper function for the jump state to more accuratly exit
	if player.total_velocity().y < 0: #if we are moving upwards
		change_state(AscendState.id()) #change to ascend state
	else: #if we are falling down
		change_state(FallState.id()) #change to fall state

	
