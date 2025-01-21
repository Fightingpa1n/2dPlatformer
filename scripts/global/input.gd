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
        emit_signal("jump_pressed")
        jump = true
    elif event.is_action_released("jump"):
        jump = false

    #Left/Right
    if event.is_action_pressed("left") or event.is_action_pressed("right"):
        if event.is_action_pressed("left"):
            emit_signal("left_pressed")
            emit_signal("horizontal_pressed", horizontal)
            left = true
        elif event.is_action_pressed("right"):
            emit_signal("right_pressed")
            emit_signal("horizontal_pressed", horizontal)
            right = true
    elif event.is_action_released("left") or event.is_action_released("right"):
        if event.is_action_released("left"):
            left = false
        elif event.is_action_released("right"):
            right = false
    
    #Up/Down
    if event.is_action_pressed("up") or event.is_action_pressed("down"):
        if event.is_action_pressed("up"):
            emit_signal("up_pressed")
            emit_signal("vertical_pressed", vertical)
            up = true
        elif event.is_action_pressed("down"):
            emit_signal("down_pressed")
            emit_signal("vertical_pressed", vertical)
            down = true
    elif event.is_action_released("up") or event.is_action_released("down"):
        if event.is_action_released("up"):
            up = false
        elif event.is_action_released("down"):
            down = false


    #========= CAMERA INPUT =========#
    if event.is_action_pressed("zoom_in"):
        emit_signal("camera_zoom_in_pressed")
    if event.is_action_pressed("zoom_out"):
        emit_signal("camera_zoom_out_pressed")
    if event.is_action_pressed("reset"):
        emit_signal("camera_reset_pressed")


func _unhandled_input(_event): #TODO: I'm not sure what exactly this is for and I don't think I need it yet but In case I do I'm gonna leave it here
    pass

    


    