@tool
extends Control
class_name DebugRoot

var _draw:DebugDraw
var _debug_window:DebugWindow

func _init():
    _debug_window = DebugWindow.new()
    _draw = DebugDraw.new()
    add_child(_debug_window)
    add_child(_draw)


func _ready():
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


