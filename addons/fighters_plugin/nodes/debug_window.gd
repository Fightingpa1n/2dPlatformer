@tool
extends PanelContainer
class_name DebugWindow

enum WindowAnchor {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}

@export var WINDOW_ANCHOR:WindowAnchor = WindowAnchor.TOP_LEFT:
    set(value):
        WINDOW_ANCHOR = value
        _update()

@export var SHOW_WINDOW:bool = true:
    set(value):
        SHOW_WINDOW = value
        _update()


func _update():
    if SHOW_WINDOW: show() #show the window
    else: hide() #hide the window

    #Anchor points
    anchor_left = 0.0 if WINDOW_ANCHOR == WindowAnchor.TOP_LEFT or WINDOW_ANCHOR == WindowAnchor.BOTTOM_LEFT else 1.0
    anchor_right = 1.0 if WINDOW_ANCHOR == WindowAnchor.TOP_RIGHT or WINDOW_ANCHOR == WindowAnchor.BOTTOM_RIGHT else 0.0
    anchor_top = 0.0 if WINDOW_ANCHOR == WindowAnchor.TOP_LEFT or WINDOW_ANCHOR == WindowAnchor.TOP_RIGHT else 1.0
    anchor_bottom = 1.0 if WINDOW_ANCHOR == WindowAnchor.BOTTOM_LEFT or WINDOW_ANCHOR == WindowAnchor.BOTTOM_RIGHT else 0.0

    #Grow
    grow_horizontal = Control.GROW_DIRECTION_BEGIN if WINDOW_ANCHOR == WindowAnchor.TOP_LEFT or WINDOW_ANCHOR == WindowAnchor.BOTTOM_LEFT else Control.GROW_DIRECTION_END
    grow_vertical = Control.GROW_DIRECTION_BEGIN if WINDOW_ANCHOR == WindowAnchor.TOP_LEFT or WINDOW_ANCHOR == WindowAnchor.TOP_RIGHT else Control.GROW_DIRECTION_END

    #Margin
    offset_left = 0.0
    offset_right = 0.0
    offset_top = 0.0
    offset_bottom = 0.0