extends ParentState_Air
class_name FallState

static func id() -> String: return "fall" #id
#while in the air whith a negative y velocity (aka. are falling down)

func enter():
	super() #call the air state enter function
	collision.toggle_jump_buffer_ray(true) #enable jump buffer ray

func exit():
	collision.toggle_jump_buffer_ray(false) #disable jump buffer ray

func physics_process(delta):
	super(delta) #call the air state physics process (mostly for gravity reset)
	
	if ground_check(): return #do the ground check (if state change occured return)
	if wall_check(): return #do the wall check (if state change occured return)

	if player.velocity.y < 0: #if we are moving upwards, change to ascend state
		change_state(AscendState.id())
		return
	move(delta) #move the player (air defaults)


func on_jump_press():
	if coyote_jump(): return #coyote jump

	#Buffer Jump
	if Settings.jump_buffer_mode == Settings.JumpBufferMode.TIMED: #when set to timed (we check air jump first since we don't care about the floor we land on and it could be dangerous)
		if air_jump(): return #air jump (if air jump is possible it will change state so we return)
		else: #if air jump not possible
			player.buffer_timer = player.BUFFER_TIME #set the buffer timer
			player.buffer_jump = true #set the buffer jump to true
			print("buffered jump")
			return
	
	elif Settings.jump_buffer_mode == Settings.JumpBufferMode.DYNAMIC: #if set to dynamic
		# var new_length = player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH * (player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER * player.total_velocity().y) #calculate lenght based on velocity
		var new_length = player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH #TODO: I broke the calculation somehow
		collision.jump_buffer_update_length(new_length) #update the length of the jump buffer ray
		if collision.did_jump_buffer_hit(): #if jump buffer hit something

			if collision.save_to_land(): #check if save to land
				player.buffer_timer = player.BUFFER_TIME #set the buffer timer
				player.buffer_jump = true #set the buffer jump to true
				print("buffered jump")
				return

			else: #if not save to land
				if air_jump(): return #air jump

				else: #if air jump not possible
					player.buffer_timer = player.BUFFER_TIME #set the buffer timer
					player.buffer_jump = true #set the buffer jump to true
					print("buffered jump")
					return

		else: #if jump buffer did not hit
			if air_jump(): return #air jump

			else: #if air jump not possible
				player.buffer_timer = player.BUFFER_TIME #set the buffer timer
				player.buffer_jump = true #set the buffer jump to true
				print("buffered jump")
				return
















	pass
	# if super(): return #cyote jump check from parent

	# var new_length = player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH + player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER * player.total_velocity().y #calculate lenght based on velocity
	# collision.jump_buffer_update_length(new_length) #update the length of the jump buffer ray
	# if player.collision.did_jump_buffer_hit():

	#     #do some ground check here to see if stuff is save to land on 
	#     var save_to_land = true #for the moment we can do it manually since there is no danger yet.

	#     if save_to_land:
	#         player.buffer_jump = true
	#         print("buffered jump")
	#         return
				
	# double_jump()

	#TODO: if the raycasts hits and it would activate bufferjump but then the player moves to the side avoiding the ground that got hit by the raycast, the bufferjump will still be activated meaning the player will jump as soon as he hits the ground again which is not good since it feels horrible
