extends Node

## this is the Input Script the Global Script that handles Input Stuff

#========= PLAYER INPUT =========#
var left:ActionKey = ActionKey.new("left") ## move left action key
var right:ActionKey = ActionKey.new("right") ## move right action key
var horizontal:ActionAxis = ActionAxis.new(left, right) ## left/right(horizontal) action axis

var up:ActionKey = ActionKey.new("up") ## move up action key
var down:ActionKey = ActionKey.new("down") ## move down action key
var vertical:ActionAxis = ActionAxis.new(down, up) ## up/down(vertical) action axis

var jump:ActionKey = ActionKey.new("jump") ## jump action key
var crouch:ActionKey = ActionKey.new("crouch") ## crouch action key


#========= CAMERA INPUT =========#
var camera_zoom_in:ActionKey = ActionKey.new("zoom_in") ## zoom in key input
var camera_zoom_out:ActionKey = ActionKey.new("zoom_out") ## zoom out key input
var camera_reset:ActionKey = ActionKey.new("reset") ## reset key input


func _input(event):
    var time_stamp:float = float(Time.get_ticks_msec() / 1000.0) #get the current time in seconds

    #========= PLAYER INPUT =========#
    left.input_update(event, time_stamp) #left
    right.input_update(event, time_stamp) #right
    horizontal.input_update() #horizontal
    
    up.input_update(event, time_stamp) #up
    down.input_update(event, time_stamp) #down
    vertical.input_update() #vertical

    jump.input_update(event, time_stamp) #jump
    crouch.input_update(event, time_stamp) #crouch

    #========= CAMERA INPUT =========#
    camera_zoom_in.input_update(event, time_stamp) #zoom in
    camera_zoom_out.input_update(event, time_stamp) #zoom out
    camera_reset.input_update(event, time_stamp) #reset


func _unhandled_input(event): #TODO: I'm not sure what exactly this is for and I don't think I need it yet but In case I do I'm gonna leave it here
    #========= PLAYER INPUT =========#
    left.unhandled_update(event) #left
    right.unhandled_update(event) #right
    horizontal.unhandled_update(event) #horizontal

    up.unhandled_update(event) #up
    down.unhandled_update(event) #down
    vertical.unhandled_update(event) #vertical

    jump.unhandled_update(event) #jump
    crouch.unhandled_update(event) #crouch

    #========= CAMERA INPUT =========#
    camera_zoom_in.unhandled_update(event) #zoom in
    camera_zoom_out.unhandled_update(event) #zoom out
    camera_reset.unhandled_update(event) #reset


func _process(_delta): #maybe I need this in the future but for now I don't think I need it
    #========= PLAYER INPUT =========#
    left.process_update(_delta) #left
    right.process_update(_delta) #right
    horizontal.process_update(_delta) #horizontal

    up.process_update(_delta) #up
    down.process_update(_delta) #down
    vertical.process_update(_delta) #vertical

    jump.process_update(_delta) #jump
    crouch.process_update(_delta) #crouch

    #========= CAMERA INPUT =========#
    camera_zoom_in.process_update(_delta) #zoom in
    camera_zoom_out.process_update(_delta) #zoom out
    camera_reset.process_update(_delta) #reset


#========= HELPER =========#
class ActionKey: ## helper class for handeling input
    var action_key:String ## the action key of the key
    var dt_threshold:float ## the time in seconds that a button can be pressed down again to be considered a double tap
    var debug:bool ## do Debug stuff
    func _init(action:String, double_tap_threshold:float=0.2, enable_debug:bool=false): ## init the action key
        action_key = action
        dt_threshold = double_tap_threshold
        debug = enable_debug

    var pressed:bool = false ## if the key is pressed
    var time_pressed:float = 0 ## the time the key is held down for
    var _last_press:float = 0 ## the time stamp when the key was last pressed down

    signal on_press #signal on the key is pressed
    signal on_release(pressed_time:float) #signal on the key is released
    signal on_double_tap #signal on the key is double tapped
    
    func _update_pressed(event) -> void: ## update the pressed state of the key
        if event.is_action_pressed(action_key): pressed = true
        elif event.is_action_released(action_key): pressed = false

    func input_update(event, time_stamp): ## update key stuff on event
        _update_pressed(event) #update the pressed state of the key
        
        if event.is_action_pressed(action_key): #if the action key is pressed
            if (time_stamp - _last_press) <= dt_threshold: #if the time since last press is applicable for a double tap (within the threshold) we emit the double tap signal
                if debug: print(action_key+" double tapped") #debug
                emit_signal("on_double_tap") #emit the on double tap signal for the controller

            _last_press = time_stamp #set the press start time to the current time
            if debug: print(action_key+" pressed") #debug
            emit_signal("on_press") #emit the on press signal for the controller
        if event.is_action_released(action_key): #if the action key is released
            time_pressed = time_stamp - _last_press #get accurate time pressed
            if debug: print(action_key+" released ("+str(time_pressed)+")") #debug
            emit_signal("on_release", time_pressed) #emit the on release signal for the controller
            time_pressed = 0 #reset the time pressed
    
    func unhandled_update(_event) -> void: ## the unhandled update of the key #TODO: I'm not sure what this is for yet
        pass
    
    func process_update(delta) -> void: ## update key variables in process
        if pressed: time_pressed += delta #if the key is pressed add the delta time to the time pressed (not as accurate as the time given in the on_release signal but good enough for most cases)

    func connect_input(press:Callable, release:Callable, double_tap:Callable): ## connect the input signals to the given functions
        self.connect("on_press", press)
        self.connect("on_release", release)
        self.connect("on_double_tap", double_tap)


class ActionAxis: ## Helper class for handeling Axis Input between two action keys #TODO: this is pretty much just the ActionKeys version of the previous thing I made. I might need to clean this up in the future (like more signals and stuff)
    var negative:ActionKey ## the negative action key
    var positive:ActionKey ## the positive action key
    var debug:bool ## do Debug stuff
    func _init(negative_action:ActionKey, positive_action:ActionKey, enable_debug:bool=false):
        positive = positive_action
        negative = negative_action
        debug = enable_debug
    
    var value:float = 0 ## the value of the axis (direction)

    signal on_direction(direction:float) #signal on the axis is pressed

    func input_update(): ## update the axis stuff on event (make sure to call this after the individal action keys have been updated)
        var previous_direction = value #store the previous direction value

        #NOTE: this is just for button presses not for analog input like a joystick which is fine for now but just saying if I wanna add controller support in the future
        match [negative.pressed, positive.pressed]: #turn the negative and positive action keys into a direction value 
            [true, false]: value = -1.0 #if negative is pressed and positive is not: direction = -1
            [false, true]: value = 1.0 #if positive is pressed and negative is not: direction = 1
            _:value = 0.0 #if both are pressed or none is pressed: direction = 0

        if previous_direction != value and value != 0.0: #if it's a new direction and not 0
            if previous_direction == 0.0 or (previous_direction < 0.0) != (value < 0.0): #if the previous direction was 0 or if the previous direction was negative and the current direction is positive or vice versa we emit the signal
                if debug: print("Axis direction ("+negative.action_key+", "+positive.action_key+"): "+str(value)) #debug
                emit_signal("on_direction", value) #emit the on press signal for the controller

    func unhandled_update(_event) -> void: ## the unhandled update of the key #TODO: I'm not sure what this is for yet
        pass
    
    func process_update(_delta) -> void: ## update key variables in process #Note: I don't think I need this yet
        pass

    func connect_input(direction:Callable): ## connect the input signals to the given functions
        self.connect("on_direction", direction)
    
