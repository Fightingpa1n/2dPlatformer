#state.gd
extends CharacterBody2D
class_name PlayerState

#this is the state class. it's extended by all the player states and is used to manage the player using a state machine or something

var player #Player reference

func _init(me_the_player: CharacterBody2D): #init function
	player = me_the_player

func enter(): #the enter function is called when the state is entered
	pass

func exit(): #the exit function is called when the state is exited
	pass

func normal_process(_delta): #Called every frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass

func physics_process(_delta): #Called every physics frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass

func on_input_left_right(_direction): 
	pass

func on_input_jump():
	pass

func on_input_down():
	pass

func on_input_up():
	pass