#player_states.gd
extends CharacterBody2D
class_name PlayerState

#the parent state for all player states!

#================ INIT ================#
var player: PlayerController #Player reference
var collision: PlayerCollision #collision reference

func _init(me_the_player: PlayerController) -> void: #init function
	player = me_the_player #player reference
	collision = player.collision #collision reference

#================ STATE METHODS ================#
func enter() -> void: #the enter function is called when the state is entered
	pass
func exit() -> void: #the exit function is called when the state is exited
	pass
func normal_process(_delta) -> void: #Called every frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass
func physics_process(_delta) -> void: #Called every physics frame. 'delta' is the elapsed time since the previous frame. can be overitten if needed
	pass

#================ INPUT METHODS ================#
func on_input_left_right(_direction) -> void: 
	pass
func on_input_jump() -> void:
	pass
func on_input_down() -> void:
	pass
func on_input_up() -> void:
	pass

#================ PHYSICS METHODS ================#
func physics_gravity(delta: float) -> void:
	player.movement_velocity.y = move_toward(player.movement_velocity.y, player.FALL_SPEED, player.FALL_ACCELERATION * delta)

func physics_deceleration(deceleration: float, delta: float) -> void: #deceleration function. used to slow down the players x velocitys 
	if abs(player.velocity.x) > 0:
		player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
	if abs(player.other_velocity.x) > 0:
		player.other_velocity.x = move_toward(player.other_velocity.x, 0, deceleration * delta)

func physics_movement_deceleration(deceleration: float, delta: float) -> void: #decelerating function for the movement velocity
	if abs(player.movement_velocity.x) > 0:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, deceleration * delta)