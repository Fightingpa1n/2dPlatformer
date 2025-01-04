@tool
extends Control
class_name DebugRoot

func _enter_tree():
    #Anchor points
    anchor_left = 0.0
    anchor_right = 1.0
    anchor_top = 0.0
    anchor_bottom = 1.0

    #Grow
    grow_horizontal = Control.GROW_DIRECTION_BOTH
    grow_vertical = Control.GROW_DIRECTION_BOTH

    #Margin
    offset_left = 0.0
    offset_right = 0.0
    offset_top = 0.0
    offset_bottom = 0.0


func _process(delta):
    _update_points(delta)

#================================ Debug Draw =================================#
@export var DRAW_DEBUG:bool = false

var screen_points:Array = [] #points
var world_points:Array = [] #points

func draw_point(_pos, _color, _size=5, _time=5.0) -> void: #draw a point on the screen
    # _pos: the position of the point on the screen (screen coordinates)
    # _color: the color of the point
    # _size: the size of the point
    # _time: the time the point will be drawn for, if set to -1, the point will be drawn forever
    screen_points.append([_pos, _color, _size, _time])

func draw_world_point(_pos, _color, _size=5, _time=5.0) -> void: #draw a point on the screen
    # _pos: the position of the point in the world
    # _color: the color of the point
    # _size: the size of the point
    # _time: the time the point will be drawn for, if set to -1, the point will be drawn forever
    world_points.append([_pos, _color, _size, _time])


func _update_points(delta):
    for point in screen_points: #for each point
        if point[3] == -1: continue #if time is set to -1, then the point will be drawn forever
        point[3] = max(0, point[3] - delta) #decrease the time
        if point[3] == 0: #if the time is 0
            screen_points.erase(point) #remove the point

    for point in world_points: #for each point
        if point[3] == -1: continue #if time is set to -1, then the point will be drawn forever
        point[3] = max(0, point[3] - delta) #decrease the time
        if point[3] == 0: #if the time is 0
            world_points.erase(point) #remove the point
    
    if DRAW_DEBUG:
        queue_redraw() #redraw

func _draw():
    if not DRAW_DEBUG: return #if we shouldn't draw, then return

    for point in screen_points: #for each point
        draw_circle(point[0], point[2], point[1]) #draw the point

    for point in world_points: #for each point
        draw_circle(Screen.world_to_screen(point[0]), point[2], point[1]) #draw the point


