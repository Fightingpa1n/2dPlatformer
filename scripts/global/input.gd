extends Node

##this is the Input Script the Global Script that handles Input Stuff

#========= Settings =========#
var double_tap_threshold:float = 0.2 ## the time in seconds that a button can be pressed down again to be considered a double tap
var double_tap_release:bool = false ## if the doubletap timer should start on press of a button or on release of a button (true = on release, false = on press)

#========= PLAYER INPUT =========#

#left/right
signal left_pressed ## signal on left button is pressed
signal left_double_tap ## signal on left button is double tapped
signal right_pressed ## signal on right button is pressed
signal right_double_tap ## signal on right button is double tapped
signal horizontal_pressed(direction:float) ## signal on either left or right button is pressed
var left:bool = false ## if left button is pressed
var left_time_pressed:float = 0 ## the time the left button is held down for
var _left_double_tap_timer:float = 0 ## the timer for the double tap of the left button
var right:bool = false ## if right button is pressed
var right_time_pressed:float = 0 ## the time the right button is held down for
var _right_double_tap_timer:float = 0 ## the timer for the double tap of the right button
var horizontal:float = 0 ## the direction of left or right input 0 if neither or both

#up/down
signal up_pressed ##signal on up button is pressed
signal down_pressed ##signal on down button is pressed
signal vertical_pressed(direction:float) ##signal on either up or down button is pressed
var up:bool = false ##if up button is pressed
var down:bool = false ##if down button is pressed
var vertical:float = 0 ##the direction of up or down input 0 if neither or both

#jump
signal jump_pressed ##signal on jump button is pressed
var jump:bool = false ##if jump button is pressed

#run (sprint)
signal run_pressed ##signal on run button is pressed
var run:bool = false ##if run button is pressed

#crouch
signal crouch_pressed ##signal on crouch button is pressed
var crouch:bool = false ##if crouch button is pressed

#========= CAMERA INPUT =========#
signal camera_zoom_in_pressed ##signal on zoom in button is pressed
signal camera_zoom_out_pressed ##signal on zoom out button is pressed
signal camera_reset_pressed ##signal on reset button is pressed

func _input(event):

    #========= PLAYER INPUT =========#
    #Left/Right
    if event.is_action_pressed("left"): left = true #on press set left to true
    elif event.is_action_released("left"): left = false #on release set left to false

    if event.is_action_pressed("right"): right = true #on press set right to true
    elif event.is_action_released("right"): right = false #on release set right to false

    var previous_horizontal = horizontal #store the previous horizontal value

    horizontal = 0 if left == right else -1 if left else 1 if right else 0 #set the horizontal value (this is just full throttle aka just for button presses not for analog input like a joystick which is fine for now but just saying if I wanna add controller support in the future)

    if previous_horizontal != horizontal and horizontal != 0: #if the previous direction was 0 we emit the signal either way
        if previous_horizontal == 0 or (previous_horizontal < 0) != (horizontal < 0): #if the previous direction was 0 or if the previous direction was negative and the current direction is positive or vice versa we emit the signal
            emit_signal("horizontal_pressed", horizontal) #emit the horizontal pressed signal

    if event.is_action_pressed("left"): emit_signal("left_pressed") #on left press emit left_pressed signal (only after having done needed calculations)
    elif event.is_action_pressed("right"): emit_signal("right_pressed") #on right press emit right_pressed signal (only after having done needed calculations)

    #Up/Down
    if event.is_action_pressed("up"): up = true #on up press set up to true
    elif event.is_action_released("up"): up = false #on up release set up to false

    if event.is_action_pressed("down"): down = true #on down press set down to true
    elif event.is_action_released("down"): down = false #on down release set down to false

    var previous_vertical = vertical #store the previous vertical value

    vertical = 0 if up == down else -1 if down else 1 if up else 0 #set the vertical value (this is just full throttle aka just for button presses not for analog input like a joystick which is fine for now but just saying if I wanna add controller support in the future)

    if previous_vertical != vertical and vertical != 0: #if the previous direction was 0 we emit the signal either way
        if previous_vertical == 0 or (previous_vertical < 0) != (vertical < 0): #if the previous direction was 0 or if the previous direction was negative and the current direction is positive or vice versa we emit the signal
            emit_signal("vertical_pressed", vertical) #emit the vertical pressed signal

    if event.is_action_pressed("up"): emit_signal("up_pressed") #on up press emit up_pressed signal (only after having done needed calculations)
    elif event.is_action_pressed("down"): emit_signal("down_pressed") #on down press emit down_pressed signal (only after having done needed calculations)

    #Jump
    if event.is_action_pressed("jump"):
        jump = true
        emit_signal("jump_pressed")
    elif event.is_action_released("jump"):
        jump = false

    #Run
    if event.is_action_pressed("run"):
        run = true
        emit_signal("run_pressed")
    elif event.is_action_released("run"):
        run = false

    #Crouch
    if event.is_action_pressed("crouch"):
        crouch = true
        emit_signal("crouch_pressed")
    elif event.is_action_released("crouch"):
        crouch = false


    #========= CAMERA INPUT =========#
    if event.is_action_pressed("zoom_in"):
        emit_signal("camera_zoom_in_pressed")
    if event.is_action_pressed("zoom_out"):
        emit_signal("camera_zoom_out_pressed")
    if event.is_action_pressed("reset"):
        emit_signal("camera_reset_pressed")


func _unhandled_input(_event): #TODO: I'm not sure what exactly this is for and I don't think I need it yet but In case I do I'm gonna leave it here
    pass

func _process(_delta): #maybe I need this in the future but for now I don't think I need it
    pass
