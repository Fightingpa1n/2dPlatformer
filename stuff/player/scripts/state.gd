extends CharacterBody2D
class_name PlayerState

#this is the state class. it's extended by all the player states and is used to manage the player using a state machine or something

#init
var player #Player reference
func _init(me_the_player: CharacterBody2D) -> void: #init function
	player = me_the_player

#state functions
func enter() -> void: #the enter function is called when the state is entered
	pass
func exit() -> void: #the exit function is called when the state is exited
	pass
func normal_process(_delta) -> void: #Called every frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass
func physics_process(_delta) -> void: #Called every physics frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass

#input functions
func on_input_left_right(_direction) -> void: 
	pass
func on_input_jump() -> void:
	pass
func on_input_down() -> void:
	pass
func on_input_up() -> void:
	pass