extends Node
class_name PlayerStateMashine

#=================== Public vars ===================#
var current_state:PlayerState ##the current state of the player
var previous_state:PlayerState ##the previous state of the player
@export var init_state:NodePath ##the initial state of the player (set in the editor)

#================ Private vars ================#
var player:PlayerController ##the player reference
var _state_queue = [] ##the queue of states to change to
var _is_transitioning = false ##if the state machine is currently transitioning between states

#=================== Init ===================#
func _ready() -> void: #on node Ready
    player = get_parent() as PlayerController #get the player reference
    await player.ready
    for child in get_children(): #for each child of the state machine
        if child is PlayerState: #if the child is a state
            if child.id() == "": #if the state has no id
                printerr("State has no id defined or is parent state!") #print error message
                child.queue_free() #remove the state
                continue #skip the state
            child.name = child.id() #set the name to the id
            child.player = player #set the player reference of the state
            child.collision = player.collision #set the collision reference of the state
            child.states = self #set the state machine reference of the state
    if init_state == NodePath(""): #if the initial state is not set
        printerr("Initial state is not set! Please set it in the editor!") #print error message
        return #do nothing
    current_state = get_node(init_state) #get the initial state
    _connect_input() #connect the input signals

#=================== State Methods ===================#
func change_state(new_state_id:String) -> void: ## the function to change the state. NOTE: currently this is just a wrapper but it's ready for more complex stuff
    _state_changer(new_state_id) #call the state changer function

func _state_changer(new_state_id:String) -> void: ## the statemashine function responsible for the actual state change
    if new_state_id == current_state.id(): return #do nothing on the same state
    if new_state_id in _state_queue: return #do nothing if the state is already in the queue
    var new_state = get_node(new_state_id) #get the new state
    if new_state == null or new_state is not PlayerState: #if the new state is not a state
        printerr("State not found or is not a state!") #print error message
        return #do nothing

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
            player.emit_signal("debug_previous_state", previous_state.id()) ## emit the debug signal for the previous state

        current_state = get_node(next_state_id) ## set the current state to the new state
        if current_state == null or current_state is not PlayerState: ## if the new state is not a state
            printerr("State not found or is not a state!") #print error message
            _is_transitioning = false #set the transitioning variable to false
            return #do nothing
        current_state.enter() #enter the new state
        player.emit_signal("state_change", next_state_id) ## emit the state change signal

    _is_transitioning = false ## set the transitioning variable to false


#============================== Input Stuff ==============================#
func _connect_input(): ##connect the Action Key signals to the Input "Translators"
    InputManager.left.connect_input(_on_left_press, _on_left_release, _on_left_dt)
    InputManager.right.connect_input(_on_right_press, _on_right_release, _on_right_dt)
    InputManager.horizontal.connect_input(_on_horizontal_direction)

    InputManager.up.connect_input(_on_up_press, _on_up_release, _on_up_dt)
    InputManager.down.connect_input(_on_down_press, _on_down_release, _on_down_dt)
    InputManager.vertical.connect_input(_on_vertical_direction)

    InputManager.jump.connect_input(_on_jump_press, _on_jump_release, _on_jump_dt)
    InputManager.crouch.connect_input(_on_crouch_press, _on_crouch_release, _on_crouch_dt)

#========== Input "Translators" ==========#
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







#TODO:

#enter ground
func enter_ground_thing(): #pls rename
    if !player.collision.is_touching_ground(): return #don't change to ground state i