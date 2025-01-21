extends PlayerState
class_name ParentState_Grounded

#The Parentstate for any Grounded States meaning the way how physics work on ground is defined here

func enter(): #on enter any grounded state should reset values like coyote time and jump counter
	pass #TODO: I don't reset values currently since I don't use them yet,
	# player.coyote_time_time = player.COYOTE_TIME
	# player.jump_counter = 0

	# if player.buffer_jump:
	# 	player.buffer_jump = false
	# 	print("jumped from the buffer")
	# 	player.change_state("jump")

func ground_check() -> bool: #checks if the player is touching the ground
	if collision.is_touching_ground(): return true
	else:
		print("falling")
		#player.change_state("fall") #TODO: commented out for the moment since I need to clean up fall first and readd it to the state machine
		return false

func on_jump(): #the jump init can be handled here since pretty much all grounded states won't need to alter it
	print("Jump!")
	#player.change_state("jump") #TODO: commented out for the moment since I need to clean up jump first and readd it to the state machine
