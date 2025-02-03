extends Node
class_name PlayerState 

static func id() -> String: return "" ## returns the id of the state (please override this each state to return the id)
## the parent state for all player states! (contains all base methods and variables)

#================ INIT ================#
var player:PlayerController ##Player reference for stuff like velocitys and state changes
var collision:PlayerCollision ##collision reference for raycasts and collision checks

## used to set player and collision reference (Please don't touch this function)
func _ready() -> void: ## the Init function get's called on states definition in the player controller and is just used to set the player and collision reference please don't touch it :)	
	if not player or not collision: ## if player or collision are not set
		print("Player State not Initialized correctly! player or collision not set!") ## print error message
		queue_free() ## destroy the state

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
func on_left_press() -> void: pass ## called when left button is pressed down
func on_left_release(_time_pressed:float) -> void: pass ## called when left button is released (time_pressed is the time the button was pressed down for)
func on_left_doubletap() -> void: pass ## called when left button is double tapped

func on_right_press() -> void: pass ## called when right button is pressed down
func on_right_release(_time_pressed:float) -> void: pass ## called when right button is released (time_pressed is the time the button was pressed down for)
func on_right_doubletap() -> void: pass ## called when right button is double tapped

func on_horizontal_direction(_direction:float) -> void: pass ## called when either left or right button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)

func on_up_press() -> void: pass ## called when up button is pressed down
func on_up_release(_time_pressed:float) -> void: pass ## called when up button is released (time_pressed is the time the button was pressed down for)
func on_up_doubletap() -> void: pass ## called when up button is double tapped

func on_down_press() -> void: pass ## called when down button is pressed down
func on_down_release(_time_pressed:float) -> void: pass ## called when down button is released (time_pressed is the time the button was pressed down for)
func on_down_doubletap() -> void: pass ## called when down button is double tapped

func on_vertical_direction(_direction:float) -> void: pass ## called when either up or down button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)

func on_jump_press() -> void: pass ## called when jump button is pressed down
func on_jump_release(_time_pressed:float) -> void: pass ## called when jump button is released (time_pressed is the time the button was pressed down for)
func on_jump_doubletap() -> void: pass ## called when jump button is double tapped

func on_crouch_press() -> void: pass ## called when crouch button is pressed down
func on_crouch_release(_time_pressed:float) -> void: pass ## called when crouch button is released (time_pressed is the time the button was pressed down for)
func on_crouch_doubletap() -> void: pass ## called when crouch button is double tapped

#================ HELPER METHODS ================#
## changes the player state to the state with the given name (defined in the player controller)
func change_state(new_state_id:String) -> void:
	player.change_state(new_state_id)

#========= Checks =========#

#========= Physics =========#
## apply gravity to the player by accelerating the fall speed until it reaches the given max fall speed
func apply_gravity(delta:float, max_fall_speed:float=player.FALL_SPEED, fall_acceleration:float=player.FALL_ACCELERATION) -> void:
	player.velocity.y = move_toward(player.velocity.y, max_fall_speed, fall_acceleration * delta)

## apply friction to the player by slowing down velocity and other velocity until it reaches 0 by a given deceleration
func apply_friction(delta:float, deceleration:float) -> void: ##physics method to slow down velocitys
	if abs(player.velocity.x) > 0: player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
	if abs(player.other_velocity.x) > 0: player.other_velocity.x = move_toward(player.other_velocity.x, 0, deceleration * delta)

## TODO: come up with a description I'm too dumb right now
func move(delta:float, max_speed:float, acceleration:float, deceleration:float) -> void:
	var horizontal_input = InputManager.horizontal.value #get input
	if horizontal_input != 0: #if there is input
		var _max_speed = max_speed * horizontal_input #set max speed to max speed times input
		var _acceleration = acceleration * delta #set acceleration to acceleration times delta
		player.movement_velocity.x = move_toward(player.movement_velocity.x, _max_speed, _acceleration)
	elif abs(player.movement_velocity.x) > 0: #if there is no input
		var _deceleration = deceleration * delta #set deceleration to deceleration times delta
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, _deceleration)

## slow down the players movement velocity down to 0 by a given deceleration value (used for smoothly stoping the player when no input is given)
func slow_down(delta:float, deceleration:float) -> void:
	if abs(player.movement_velocity.x) > 0:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, deceleration * delta)
