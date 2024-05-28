#controller.gd
extends CharacterBody2D

#this is the main Player Controller script

#=== constant values ===
@export_category("Player Settings")
@export_group("Gravity Settings")
@export var FALL_SPEED = 500.0
@export var FALL_ACCELERATION = 1030.0
@export var GROUND_DECELERATION = 3600.0

@export_group("Movement Settings")
@export var WALK_SPEED = 300.0
@export var WALK_ACCELERATION = 3600.0
@export var WALK_DECELERATION = 3600.0
@export_subgroup("Air Movement Settings")
@export var AIR_MOVE_SPEED = 300.0
@export var AIR_MOVE_ACCELERATION = 360.0
@export var AIR_MOVE_DECELERATION = 360.0

@export_group("Jump Settings")
@export var JUMP_FORCE = 400.0
@export var MIN_JUMP_TIME = 0.1
@export var MAX_JUMP_TIME = 0.5
@export_subgroup("Double Jump stuff")
@export var EXTRA_JUMPS = 1

@export_group("Wall Settings")
@export var WALL_SLIDE_SPEED = 100.0
@export var WALL_SLIDE_SPEED_FAST = 150.0
@export var WALL_SLIDE_SPEED_SLOW = 50.0
@export var WALL_SLIDE_ACCELERATION = 3600.0
@export var WALL_SLIDE_DECELERATION = 3600.0
@export_subgroup("Wall Jump Settings")
@export var WALL_JUMP_FORCE = 400.0
@export var WALL_JUMP_DIRECTION = Vector2(-1, -1) #in this value persumes that the wall is on the left and the player is jumping right

@export_group("Raycast Settings")
@export var CEILING_RAYCAST_LENGTH = 2.5
@export var WALL_RAYCAST_LENGTH = 2.5
@export var FLOOR_RAYCAST_LENGTH = 2.5
@export_flags_2d_physics var RAYCAST_COLLISION_MASK = 1

@export_subgroup("Jump Buffer Settings")
@export var JUMP_BUFFER_RAYCAST_INITAL_LENGTH = 20.0
@export var JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER = 100.0

@export_group("Abilities (or just other stuff idk)")
@export_subgroup("fastfall thingy") #todo: find a better name
@export var FASTFALL_SPEED = 1000.0
@export var FASTFALL_ACCELERATION = 2060.0

@export_subgroup("coyote_time")
@export var COYOTE_TIME = 0.1

#=== player variables ===
var movement_velocity = Vector2() #the velocity for movement
var other_velocity = Vector2() #the velocity for other stuff like powaaa
var jump_time = 0.0
var buffer_jump = false
var coyote_time_time= 0.0
var jump_counter = 0


#=== private variables ===
var current_state: PlayerState = null
var current_state_name = ""
var player_states = {}
var state_queue = []
var is_transitioning = false
var collision: CollisionShape2D
var _ui #for testing


func _ready():
	collision = $collision

	_ui = get_node("../UI") #for testing

	# Initialize all states
	player_states["idle"] = State_Idle.new(self)
	player_states["walk"] = State_Walk.new(self)
	player_states["ascend"] = State_Ascend.new(self)
	player_states["fall"] = State_Fall.new(self)
	player_states["fast_fall"] = State_FastFall.new(self)
	player_states["jump"] = State_Jump.new(self)
	player_states["walled"] = State_Walled.new(self)
	player_states["powaad"] = State_Powaad.new(self)

	# Set the initial state
	change_state("idle")

func _physics_process(delta):
	#we split the velocity into mutliple vectors to make it easier with multiple velocity sources clashing with each other

	#subtract the additinal velocitys
	velocity -= movement_velocity
	velocity -= other_velocity

	_ui.update_debug_ui(current_state_name, velocity, movement_velocity, other_velocity, whole_velocity())
	
	current_state.physics_process(delta)

	#readd the different velocitie stuff.
	velocity += movement_velocity
	velocity += other_velocity
	
	move_and_slide()

func _process(delta):
	current_state.normal_process(delta)

func _input(event): #Called when there is an input event.

	#this currently get's called on every input event but we just want the relevant ones we defined in the input map
	if event.is_action_pressed("left") or event.is_action_pressed("right"):
		var movement = event.get_action_strength("right") - event.get_action_strength("left")
		current_state.on_input_left_right(movement)

	if event.is_action_pressed("jump"):
		current_state.on_input_jump()

	if event.is_action_pressed("down"):
		current_state.on_input_down()

	if event.is_action_pressed("up"):
		current_state.on_input_up()


func change_state(new_state):
	if new_state not in player_states:
		print("Error: State not found")
		return

	state_queue.append(new_state)
	
	# Prevent re-entry into the function if it's already processing the queue
	if is_transitioning:
		return
	
	is_transitioning = true
	while state_queue.size() > 0:
		var next_state = state_queue.pop_front()  # Retrieve and remove the first element from the queue

		if current_state != null:
			current_state.exit()

		current_state = player_states[next_state]
		current_state_name = next_state
		current_state.enter()
		print("Entering state: " + player_states.find_key(current_state))

	is_transitioning = false


func powaaa(direction, force):
	other_velocity = direction.normalized() * force #multiply the direction vector by the force to get the force vector and set is as velocity

func whole_velocity():
	return velocity + movement_velocity + other_velocity #return the sum of all velocitys so we can use it to check for whole velocity

#todo: make a change state function where you can define a parent state like grounded or air
#      and it will then automatically change to the correct state that extends said parent state
