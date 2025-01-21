extends CharacterBody2D
class_name PlayerController

#this is the main Player Controller script containing values, functions and being responsible for the state machine

#=== constant values ===#
@export_category("Player Settings")
@export_group("Physics Settings")
@export var FALL_SPEED = 500.0 #the speed the player falls at (at a maximum)
@export var FALL_ACCELERATION = 1030.0 #the acceleration applied to the fall speed (basically it's just a fancy way of saying gravity)
@export_subgroup("Grounded")
@export var GROUND_DECELERATION = 3600.0 #the deceleration applied to each velocity vector when the player is grounded
@export_subgroup("Air")
@export var AIR_DECELERATION = 3600.0 #the deceleration applied to each velocity vector when the player is in the air

@export_group("Movement Settings")
@export var WALK_SPEED = 300.0 #the speed the player walks at (at a maximum)
@export var WALK_ACCELERATION = 3600.0 #the acceleration applied to the walk speed
@export var WALK_DECELERATION = 3600.0 #the deceleration applied to the walk speed
@export_subgroup("Air Movement Settings")
@export var AIR_MOVE_SPEED = 300.0 #the speed the player moves in the air (at a maximum)
@export var AIR_MOVE_ACCELERATION = 3600.0 #the acceleration applied to the air move speed
@export var AIR_MOVE_DECELERATION = 3600.0 #the deceleration applied to the air move speed

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
var jump_time = 0.0
var buffer_jump = false
var coyote_time_time= 0.0
var jump_counter = 0

@onready var collision: CollisionShape2D = %collision


#=== debug signals ===# #currrently unused
signal state_change(state_name:String)
signal velocity_update(velocity:Vector2, movement_velocity:Vector2, other_velocity:Vector2)
signal pre_process_velocity_update(velocity:Vector2, movement_velocity:Vector2, other_velocity:Vector2)

#=== State variables ===#
var current_state: PlayerState = null
var current_state_name = ""
var states = {}
var state_queue = []
var is_transitioning = false


func _ready(): #Ready The player States and stuff

	states["idle"] = State_Idle.new(self)
	states["walk"] = State_Walk.new(self)


	change_state("idle") #set inital state

	#connect InputSignals
	InputManager.connect("jump_pressed", _on_jump)
	InputManager.connect("left_pressed", _on_left)
	InputManager.connect("right_pressed", _on_right)
	InputManager.connect("horizontal_pressed", _on_horizontal)
	InputManager.connect("up_pressed", _on_up)
	InputManager.connect("down_pressed", _on_down)
	InputManager.connect("vertical_pressed", _on_vertical)



#========== Input Signals ==========#
func _on_jump(): current_state.on_jump() #jump signal
func _on_left(): current_state.on_left() #left signal
func _on_right(): current_state.on_right() #right signal
func _on_horizontal(direction:float): current_state.on_horizontal(direction) #horizontal signal
func _on_up(): current_state.on_up() #up signal
func _on_down(): current_state.on_down() #down signal
func _on_vertical(direction:float): current_state.on_vertical(direction) #vertical signal


#========== State Machine ==========#
func change_state(new_state) -> void:
	if new_state not in states:
		printerr("Error: State not found: " + new_state)
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

		current_state = states[next_state]
		current_state_name = next_state
		current_state.enter()
		emit_signal("state_change", current_state_name)
	
	is_transitioning = false


#========== Handling Stuff ==========#
func _physics_process(delta):
	#NOTE: we split the velocity into mutliple vectors to make it easier with multiple velocity sources clashing with each other

	#subtract the different velocitys from the main velocity
	velocity -= movement_velocity
	velocity -= other_velocity

	emit_signal("pre_process_velocity_update", velocity, movement_velocity, other_velocity) #emit current velocity

	current_state.physics_process(delta)

	emit_signal("velocity_update", velocity, movement_velocity, other_velocity) #emit current velocity

	#readd the different velocitie stuff.
	velocity += movement_velocity
	velocity += other_velocity
	
	move_and_slide()

func _process(delta): current_state.normal_process(delta) #normal process


func powaaa(direction, force) -> void:
	other_velocity = direction.normalized() * force #multiply the direction vector by the force to get the force vector and set is as velocity

func total_velocity() -> Vector2: return velocity + movement_velocity + other_velocity ##returns the total of all velocitys combined, to see how fast the player is going in total

#TODO: make a change state function where you can define a parent state like grounded or air
#      and it will then automatically change to the correct state that extends said parent state
#NOTE: I don't think this is needed if the States are good enough setup that they correctly switch between one another
