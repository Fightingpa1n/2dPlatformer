extends CharacterBody2D
class_name PlayerState

##the parent state for all player states!

#================ INIT ================#
var player:PlayerController ##Player reference for stuff like velocitys and state changes
var collision:PlayerCollision ##collision reference for raycasts and collision checks

func _init(the_player:PlayerController) -> void: ##the Init function get's called on states definition in the player controller and is just used to set the player and collision reference please don't touch it :)	
	player = the_player
	collision = the_player.collision

#================ STATE METHODS ================#
func enter() -> void: ##the enter function is called when the state is entered and should be used to reset values or activate raycasts and stuff like that
	pass

func exit() -> void: ##the exit function is called when the state is exited and is for cleanup and deactivating raycasts and stuff like that
	pass

func normal_process(_delta) -> void: ##Called every frame. 'delta' is the elapsed time since the previous frame. intended for logic stuff like timers, checks and that jazz
	pass

func physics_process(_delta) -> void: ##Called every physics frame. 'delta' is the elapsed time since the previous frame. intended for applieng/changing velocitys and stuff like that
	pass

#================ INPUT METHODS ================#
func on_jump() -> void: pass ##called when jump button is pressed
func on_left() -> void: pass ##called when left button is pressed
func on_right() -> void: pass ##called when right button is pressed
func on_horizontal(direction:float) -> void: pass ##called when either left or right button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)
func on_up() -> void: pass ##called when up button is pressed
func on_down() -> void: pass ##called when down button is pressed
func on_vertical(direction:float) -> void: pass ##called when either up or down button is pressed. the passed float is the direction of the input so a range from -1 to 1 (0 if neither or both)


#================ HELPER METHODS ================# #helper methods for the states
#========= Checks =========#

#========= Physics =========# #TODO: I need to take a look at these again maybe change how they work or at the very least give them better names and comments
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
