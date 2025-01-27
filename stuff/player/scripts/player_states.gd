extends CharacterBody2D
class_name PlayerState 

## the parent state for all player states! (contains all base methods and variables)

#================ INIT ================#
var player:PlayerController ##Player reference for stuff like velocitys and state changes
var collision:PlayerCollision ##collision reference for raycasts and collision checks

## used to set player and collision reference (Please don't touch this function)
func _init(the_player:PlayerController) -> void: ## the Init function get's called on states definition in the player controller and is just used to set the player and collision reference please don't touch it :)	
	player = the_player
	collision = the_player.collision

#================ STATE METHODS ================#
## called when the state is entered (for reseting values and activating raycasts and stuff like that)
func enter() -> void:
	pass

## called when the state is exited (for cleanup and deactivating raycasts and stuff like that)
func exit() -> void:
	pass

#================ MAIN METHODS ================#
##Called every frame. 'delta' is the elapsed time since the previous frame. intended for logic stuff like timers, checks and that jazz
func normal_process(_delta:float) -> void:
	pass

## Called every physics frame. 'delta' is the elapsed time since the previous frame. intended for applieng/changing velocitys and stuff like that
func physics_process(_delta:float) -> void:
	pass

#================ INPUT METHODS ================#
func on_jump() -> void: pass ## called when jump button is pressed

func on_left() -> void: pass ## called when left button is pressed
func on_right() -> void: pass ## called when right button is pressed
func on_horizontal(_direction:float) -> void: pass ## called when either left or right button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)

func on_up() -> void: pass ## called when up button is pressed
func on_down() -> void: pass ## called when down button is pressed
func on_vertical(_direction:float) -> void: pass ## called when either up or down button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)

#================ HELPER METHODS ================#
## changes the player state to the state with the given name (defined in the player controller)
func change_state(new_state:String) -> void:
	player.change_state(new_state)

#========= Checks =========#

#========= Physics =========#
## apply gravity to the player by accelerating the fall speed until it reaches the given max fall speed
func apply_gravity(delta:float, fall_acceleration:float=player.FALL_ACCELERATION, max_fall_speed:float=player.FALL_SPEED) -> void:
	player.movement_velocity.y = move_toward(player.movement_velocity.y, max_fall_speed, fall_acceleration * delta)

## apply friction to the player by slowing down velocity and other velocity until it reaches 0 by a given deceleration
func apply_friction(delta:float, deceleration:float) -> void: ##physics method to slow down velocitys
	if abs(player.velocity.x) > 0: player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
	if abs(player.other_velocity.x) > 0: player.other_velocity.x = move_toward(player.other_velocity.x, 0, deceleration * delta)

## slow down the players movement velocity down to 0 by a given deceleration value (used for smoothly stoping the player when no input is given)
func slow_down(delta:float, deceleration:float) -> void:
	if abs(player.movement_velocity.x) > 0:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, deceleration * delta)