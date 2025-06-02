extends AscendState
class_name JumpState

#this is the jump state, which is when the player is moving upwards in the air it is different from jump

static func id() -> String: return "jump" #id

func enter():
	super() #call the air state enter function
	player.jump_time = 0 #reset jump time
	player.released_jump = false #reset released jump
	player.coyote_timer = 0 #reset the coyote timer (as to not allow for multiple coyote jumps)

	player.jump_counter += 1 #increment the jump counter

	player.gravity = player.JUMP_GRAVITY #set the gravity to jump gravity
	player.velocity.y = -player.JUMP_FORCE #apply the jump force #TODO: check for last state to differ jump forces

func exit():
	super() #call the air state exit function
	player.jump_time = 0 #reset jump time

func physics_process(delta):
	ledge_forgivness()
	if ceiling_hit(): return #check if the player is hitting the ceiling (if state change occured return)
	
	move(delta)

	player.jump_time += delta #increment the jump time

	if InputManager.jump.pressed: #while holding the jump button
		if player.jump_time <= player.JUMP_TIME: #if the jump time is less than the max jump time
			player.gravity = lerp(player.JUMP_GRAVITY, player.GRAVITY, player.jump_time/player.JUMP_TIME) #gradually move from the JUMP_GRAVITY back to the normal gravity
		else: #if the jump time is more than the max jump time
			_exit_jump() #stop jumping
			return
	
	else: #if the jump button is released
		player.gravity = player.RELEASE_GRAVITY #set the gravity to the release gravity
		player.released_jump = true #set the released jump to true
		_exit_jump() #stop jumping
		return
	
	apply_gravity(delta) #apply gravity


func on_jump_press(): pass #override the on_jump_press of air states to do nothing

func on_jump_release(_time_pressed:float): #when we release the jump button
	_exit_jump() #stop jumping
	return

func _exit_jump(): ## a helper function for the jump state to more accuratly exit
	if player.velocity.y < 0: #if we are moving upwards
		change_state(AscendState.id()) #change to ascend state
	else: #if we are falling down
		change_state(FallState.id()) #change to fall state
