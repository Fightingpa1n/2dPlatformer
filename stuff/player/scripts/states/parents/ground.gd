#states/parents/ground.gd
extends GrandParentState
class_name ParentState_Ground

#The Parentstate for any Grounded States meaning the way how physics work on ground is defined here

func enter():
	#reset any values that need to be reset when entering any grounded state
	player.coyote_time_time = player.COYOTE_TIME
	player.jump_counter = 0

	if player.buffer_jump:
		player.buffer_jump = false
		print("jumped from the buffer")
		player.change_state("jump")

func ground_check(): #checks for ground
	if not player.collision.is_touching_ground():
		player.change_state("fall")

func on_input_jump():
	#the jump init can be handled here since pretty much all grounded states won't need to alter it
	player.change_state("jump")