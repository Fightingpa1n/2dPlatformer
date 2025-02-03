extends CharacterBody2D
class_name PlayerController

#this is the main Player Controller script containing values, functions and being responsible for the state machine

#=== constant values ===# #TODO: clean up values (especially the names)
@export_category("Player Settings")
@export_group("Physics Settings")
@export var FALL_SPEED = 500.0 #the speed the player falls at (at a maximum)
@export var FALL_ACCELERATION = 1030.0 #the acceleration applied to the fall speed (basically it's just a fancy way of saying gravity)
@export_subgroup("Friction")
@export var GROUND_FRICTION = 3600.0 ## the deceleration applied to velocitys when the player is on the ground
@export var AIR_FRICTION = 3600.0 ## the deceleration applied to velocitys when the player is in the air

@export_group("Movement Settings")
@export var WALK_SPEED = 300.0 ## the speed the player walks at (at a maximum)
@export var GROUND_MOVE_ACCELERATION = 3600.0 ## the movment acceleration on the ground
@export var GROUND_MOVE_DECELERATION = 3600.0 ## the movment deceleration on the ground
@export_subgroup("Run Settings")
@export var RUN_SPEED = 600.0 ## the speed the player runs at (at a maximum)
@export var RUN_ACCELERATION = 3600.0 ## the movment acceleration when running
@export var RUN_DECELERATION = 3600.0 ## the movment deceleration when running
@export_subgroup("Crouch Settings")
@export var CROUCH_SPEED = 150.0 ## the speed the player crouches at (at a maximum)
@export var CROUCH_ACCELERATION = 3600.0 ## the movment acceleration when crouching
@export var CROUCH_DECELERATION = 3600.0 ## the movment deceleration when crouching
@export_subgroup("Slide Settings")
@export var SLIDE_DECELERATION = 500.0 ## the deceleration applied to the player when sliding
@export_subgroup("Air Movement Settings")
@export var AIR_MOVE_SPEED = 300.0 ## the speed the player moves in the air (at a maximum)
@export var AIR_MOVE_ACCELERATION = 3600.0 ## the movment acceleration in the air
@export var AIR_MOVE_DECELERATION = 3600.0 ## the movment deceleration in the air

@export_group("Jump Settings")
@export var JUMP_FORCE = 400.0 #the force applied to the player when jumping
@export var MIN_JUMP_TIME = 0.1 #the time the jump force is applied minumum when pressing the jump button
@export var MAX_JUMP_TIME = 0.5 #the time the jump button can be held down after the minimum was reached to apply the jump force
@export_subgroup("Double Jump stuff")
@export var EXTRA_JUMPS = 1 #the amount of extra jumps the player can do (0 = no extra jumps)

@export_group("Wall Settings")
@export var WALL_SLIDE_SPEED:float = 100.0
@export var WALL_SLIDE_SPEED_FAST:float = 150.0
@export var WALL_SLIDE_SPEED_SLOW:float = 50.0
@export var WALL_SLIDE_ACCELERATION:float = 3600.0
@export var WALL_SLIDE_DECELERATION:float = 3600.0
@export_subgroup("Reset Settings")
@export var RESET_JUMP_COUNTER_ON_WALL:bool = false
@export_subgroup("Wall Jump Settings")
@export var WALL_JUMP_FORCE:float = 400.0
@export var WALL_JUMP_DIRECTION:Vector2 = Vector2(-1, -1) #in this value persumes that the wall is on the left and the player is jumping right

@export_group("Raycast Settings")
@export var CEILING_RAYCAST_LENGTH = 2.5 #the length of the raycast for the ceiling check
@export var WALL_RAYCAST_LENGTH = 2.5 #the length of the raycast for the wall check
@export var FLOOR_RAYCAST_LENGTH = 2.5 #the length of the raycast for the floor check
@export_flags_2d_physics var RAYCAST_COLLISION_MASK = 1 #the collision mask for the collision checks
@export_subgroup("Jump Buffer Settings")
@export var JUMP_BUFFER_RAYCAST_INITAL_LENGTH = 20.0 #the inital length of the raycast for the jump buffer
@export var JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER = 100.0 #bassically how much the velocity influences the length of the raycast

@export_group("Abilities (or just other stuff idk)")
@export_subgroup("fastfall thingy") #todo: find a better name
@export var FASTFALL_SPEED = 1000.0
@export var FASTFALL_ACCELERATION = 2060.0
@export_subgroup("coyote_time")
@export var COYOTE_TIME = 0.1

#TODO: Playtest alot and find better values

#=== player variables ===#
var movement_velocity = Vector2() #the velocity for movement
var other_velocity = Vector2() #the velocity for other stuff like powaaa

#=== player state variables ===# (used by the differnet individual states) #Note: maybe I should change the way this works to dynamically do that so they get added to like a list or something and only get used while active or something like that
var jump_time = 0.0
var buffer_jump = false
var coyote_time_time= 0.0
var jump_counter = 0

@onready var collision:PlayerCollision = %collision ## the collision object for the player (that handles collisions and raycasts)

#=== debug signals ===# #currrently unused #TODO: Add Debug Stuff again so signals are used again
signal state_change(state_name:String)
signal velocity_update(velocity:Vector2, movement_velocity:Vector2, other_velocity:Vector2)
signal pre_process_velocity_update(velocity:Vector2, movement_velocity:Vector2, other_velocity:Vector2)

#=== State variables ===#
var states = {}  ## states Dictionary where all states are stored by their id
var current_state:PlayerState = null ## the current state the player is in
var previous_state:PlayerState = null ## the previous state the player was in

func _ready(): #Ready The player States and stuff
	add_state(IdleState)
	add_state(WalkState)
	add_state(RunState)
	add_state(CrouchState)
	add_state(SlideState)
	add_state(FallState)
	add_state(FastFallState)
	add_state(AscendState)

	current_state = states[IdleState.id()] #set default state to idle #Note: since this set's it direcrly instead of using the state changer, this will skip the enter method of the state

	#connect InputSignals
	InputManager.left.connect_input(_on_left_press, _on_left_release, _on_left_dt)
	InputManager.right.connect_input(_on_right_press, _on_right_release, _on_right_dt)
	InputManager.horizontal.connect_input(_on_horizontal_direction)

	InputManager.up.connect_input(_on_up_press, _on_up_release, _on_up_dt)
	InputManager.down.connect_input(_on_down_press, _on_down_release, _on_down_dt)
	InputManager.vertical.connect_input(_on_vertical_direction)

	InputManager.jump.connect_input(_on_jump_press, _on_jump_release, _on_jump_dt)
	InputManager.crouch.connect_input(_on_crouch_press, _on_crouch_release, _on_crouch_dt)

#========== Input Signals ==========#
func _on_left_press(): current_state.on_left_press() #left|on press
func _on_left_release(time_pressed: float): current_state.on_left_release(time_pressed) #left|on release
func _on_left_dt(): current_state.on_left_doubletap() #left|double tap

func _on_right_press(): current_state.on_right_press() #right|on press
func _on_right_release(time_pressed: float): current_state.on_right_release(time_pressed) #right|on release
func _on_right_dt(): current_state.on_right_doubletap() #right|double tap

func _on_horizontal_direction(direction:float): current_state.on_horizontal_direction(direction) #horizontal|direction

func _on_up_press(): current_state.on_up_press() #up|on press
func _on_up_release(time_pressed: float): current_state.on_up_release(time_pressed) #up|on release
func _on_up_dt(): current_state.on_up_doubletap() #up|double tap

func _on_down_press(): current_state.on_down_press() #down|on press
func _on_down_release(time_pressed: float): current_state.on_down_release(time_pressed) #down|on release
func _on_down_dt(): current_state.on_down_doubletap() #down|double tap

func _on_vertical_direction(direction:float): current_state.on_vertical_direction(direction) #vertical|direction

func _on_jump_press(): current_state.on_jump_press() #jump|on press
func _on_jump_release(time_pressed: float): current_state.on_jump_release(time_pressed) #jump|on release
func _on_jump_dt(): current_state.on_jump_doubletap() #jump|double tap

func _on_crouch_press(): current_state.on_crouch_press() #crouch|on press
func _on_crouch_release(time_pressed: float): current_state.on_crouch_release(time_pressed) #crouch|on release
func _on_crouch_dt(): current_state.on_crouch_doubletap() #crouch|double tap

#========== States ==========#
func add_state(state_class:GDScript): ## add a state to the state machine
	var state_instance = state_class.new() #instantiate the state

	if state_instance is not PlayerState: #check if the state is a PlayerState
		printerr("Trying to add a state that is not a PlayerState: " + state_instance)
		return

	if not state_instance.id(): #check if the state has an id
		printerr("State has no id, make sure it has a static id variable: " + state_instance)
		return
	
	if state_instance.id() in states: #check if the state is already in the state machine
		printerr("State with this id already exists: " + state_instance.id())
		return

	state_instance.player = self #set the player reference
	state_instance.collision = collision #set the collision reference
	states[state_instance.id()] = state_instance

#========== State Machine ==========#
var _state_queue = [] ## the queue of states to change to
var _is_transitioning = false ## if the state machine is currently transitioning between states

func _state_changer(new_state_id:String) -> void: ## the statemashine function responsible for the actual state change
	if new_state_id not in states: ## check if the state exists
		printerr("Error: State not found: " + new_state_id)
		return

	_state_queue.append(new_state_id) ## add the state to the queue

	## Prevent re-entry into the function if it's already processing the queue
	if _is_transitioning:
		return

	_is_transitioning = true ## set the transitioning variable to true
	while _state_queue.size() > 0: ## loop through the queue
		var next_state_id = _state_queue.pop_front() ## Retrieve and remove the first element from the queue

		if current_state != null: ## if there is a current state
			current_state.exit() ## exit the current state
			previous_state = current_state ## set the previous state to the current state

		print("Changing State to: "+next_state_id) ## print the state change
		current_state = states[next_state_id] ## set the current state to the new state
		current_state.enter() ## enter the new state
		emit_signal("state_change", next_state_id) ## emit the state change signal

	_is_transitioning = false ## set the transitioning variable to false

func change_state(new_state_id:String) -> void: ## the function to change the state. NOTE: currently this is just a wrapper but it's ready for more complex stuff
	_state_changer(new_state_id) #call the state changer function

#========== Handling Stuff ==========#
func _physics_process(delta): #physics process

	#subtract the different velocitys from the main velocity
	velocity -= movement_velocity
	velocity -= other_velocity

	emit_signal("pre_process_velocity_update", velocity, movement_velocity, other_velocity) #emit current velocity

	current_state.physics_process(delta)

	emit_signal("velocity_update", velocity, movement_velocity, other_velocity) #emit current velocity

	#readd the different velocitie stuff.
	velocity += movement_velocity
	velocity += other_velocity
	
	var did_collide = move_and_slide() #apply velocity and stuff and then check for physics collisions

	if did_collide: #reset velocitys if we collide with stuff
		for i in range(get_slide_collision_count()):
			var slide_collision = get_slide_collision(i)
			var normal = slide_collision.get_normal()

			if abs(normal.y) > 0.7: #Ground/ceiling collision
				velocity.y = 0
				movement_velocity.y = 0
				other_velocity.y = 0
	
			elif abs(normal.x) > 0.7: #Wall collision
				velocity.x = 0
				movement_velocity.x = 0
				other_velocity.x = 0


func _process(delta): current_state.normal_process(delta) #normal process

#========== Helper Functions ==========#
func total_velocity() -> Vector2: return velocity + movement_velocity + other_velocity ##returns the total of all velocitys combined, to see how fast the player is going in total 

func get_current_state() -> String: return current_state.id() ## returns the id of the current state
func get_previous_state() -> String: return previous_state.id() ## returns the id of the previous state

#TODO: make a change state function where you can define a parent state like grounded or air
#      and it will then automatically change to the correct state that extends said parent state
#NOTE: I don't think this is needed if the States are good enough setup that they correctly switch between one another
