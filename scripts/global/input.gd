extends Node

##this is the Input Script the Global Script that handles Input Stuff

#========= PLAYER INPUT =========#

#jump
signal jump_pressed ##signal on jump button is pressed
var jump:bool = false ##if jump button is pressed

#left/right
signal left_pressed ##signal on left button is pressed
signal right_pressed ##signal on right button is pressed
signal horizontal_pressed(direction:float) ##signal on either left or right button is pressed
var left:bool = false ##if left button is pressed
var right:bool = false ##if right button is pressed
var horizontal:float = 0 ##the direction of left or right input 0 if neither or both

#up/down
signal up_pressed ##signal on up button is pressed
signal down_pressed ##signal on down button is pressed
signal vertical_pressed(direction:float) ##signal on either up or down button is pressed
var up:bool = false ##if up button is pressed
var down:bool = false ##if down button is pressed
var vertical:float = 0 ##the direction of up or down input 0 if neither or both

#========= CAMERA INPUT =========#
signal camera_zoom_in_pressed ##signal on zoom in button is pressed
signal camera_zoom_out_pressed ##signal on zoom out button is pressed
signal camera_reset_pressed ##signal on reset button is pressed

func _input(event):
    #========= PLAYER INPUT =========#

    #Jump
    if event.is_action_pressed("jump"):
        jump = true
        emit_signal("jump_pressed")
    elif event.is_action_released("jump"):
        jump = false

    #Left/Right
    if event.is_action_pressed("left"): left = true #on press set left to true
    elif event.is_action_released("left"): left = false #on release set left to false

    if event.is_action_pressed("right"): right = true #on press set right to true
    elif event.is_action_released("right"): right = false #on release set right to false


    # this is the pseudo code for the horizontal input (I'm gonna delete this later I just want to keep this here for reference for the time being)

    # var previous_horizontal = horizontal #store the previous horizontal value

    # if left and right: horizontal = 0 #if both left and right are pressed then we are not moving
    # elif left: horizontal = -1 #if left is pressed then we are moving left
    # elif right: horizontal = 1 #if right is pressed then we are moving right
    # else: horizontal = 0 #if neither left or right are pressed then we are not moving

    # #check if horizontal has a different direction than before. like if before was either 0 or the opposite direction we have to emit the signal but if we just increase a side we don't have to emit the signal
    # #like if previous = 0 and now = 1 we emit true (we went from not moving to moving right)
    # #if previous = -1 and now = 1 we emit true (we went from moving left to moving right)
    # #if previous = 0.5 and now = 1 we emit false (we just moved more to the right but we are still moving right)

    # if previous_horizontal != horizontal: #if they are not the same we check stuff
    #     if horizontal != 0: #we don't care if the new direction is 0 because we are not moving
    #         if previous_horizontal == 0: #if the previous direction was 0 we emit the signal either way
    #             emit_signal("horizontal_pressed", horizontal)

    #         else: #now we check if we are going into the opposite direction or if we just increased the current direction
    #             var previous_negative = previous_horizontal < 0 #if the previous direction was negative
    #             var current_negative = horizontal < 0 #if the current direction is negative

    #             if previous_negative != current_negative: #if they are not the same we emit the signal
    #                 emit_signal("horizontal_pressed", horizontal)

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



    #========= CAMERA INPUT =========#
    if event.is_action_pressed("zoom_in"):
        emit_signal("camera_zoom_in_pressed")
    if event.is_action_pressed("zoom_out"):
        emit_signal("camera_zoom_out_pressed")
    if event.is_action_pressed("reset"):
        emit_signal("camera_reset_pressed")


func _unhandled_input(_event): #TODO: I'm not sure what exactly this is for and I don't think I need it yet but In case I do I'm gonna leave it here
    pass

func _process(_delta): #for continued updates of values, in case the input function misses something. I'll just leave it here since I'm not entirely sure if I need it, so just to be safe
    if Input.is_action_pressed("left"): left = true
    else: left = false
    if Input.is_action_pressed("right"): right = true
    else: right = false
    horizontal = Input.get_axis("left", "right")

    if Input.is_action_pressed("up"): up = true
    else: up = false
    if Input.is_action_pressed("down"): down = true
    else: down = false
    vertical = Input.get_axis("up", "down")


    