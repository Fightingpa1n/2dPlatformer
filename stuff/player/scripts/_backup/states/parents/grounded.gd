#grounded/parents/air.gd
extends PlayerState
class_name ParentState_Grounded

#this is the parent state for grounded states (idle, walk, run, crouch, etc)

func enter():
	#reset values here that should be reset on entering a grounded state
	player.jump_time = 0.0
	player.coyote_time_time = player.COYOTE_TIME
	player.jump_counter = 0

	if player.buffer_jump:
		player.buffer_jump = false
		print("jumped from the buffer")
		player.change_state("jump")


func ground_check(): #a recyclable function for checking the ground
	if player.collision.is_touching_ground():
		return true
	else:
		player.change_state("fall")
		return false


func on_input_jump():
	#the jump init can be handled here since pretty much all grounded states won't need to alter it
	player.change_state("jump")

