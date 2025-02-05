@tool
extends Control
class_name DebugRoot

@onready var _draw:DebugDraw = get_child(0)
@onready var _debug_window:DebugWindow = get_child(1)

func _ready():
    _editor_update() #update the editor

func _editor_update():
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

