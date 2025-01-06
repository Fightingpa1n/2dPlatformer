@tool
extends PanelContainer
class_name DebugWindow

enum WindowAnchor { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

@export var WINDOW_ANCHOR: WindowAnchor = WindowAnchor.TOP_LEFT:
    set(value):
        WINDOW_ANCHOR = value
        _update()

@export var SHOW_WINDOW: bool = true:
    set(value):
        SHOW_WINDOW = value
        _update()

@export var WINDOW_HEIGHT: int = 200:
    set(value):
        WINDOW_HEIGHT = value
        _update()

@export var WINDOW_WIDTH: int = 200:
    set(value):
        WINDOW_WIDTH = value
        _update()

func _enter_tree():
    _update()

func _update():
    if SHOW_WINDOW: show()
    else: hide()

    custom_minimum_size = Vector2(WINDOW_WIDTH, WINDOW_HEIGHT)

    # Set anchor and margin based on WINDOW_ANCHOR
    match WINDOW_ANCHOR:
        WindowAnchor.TOP_LEFT:
            anchor_left = 0.0
            anchor_top = 0.0
            anchor_right = 0.0
            anchor_bottom = 0.0
        WindowAnchor.TOP_RIGHT:
            anchor_left = 1.0
            anchor_top = 0.0
            anchor_right = 1.0
            anchor_bottom = 0.0
        WindowAnchor.BOTTOM_LEFT:
            anchor_left = 0.0
            anchor_top = 1.0
            anchor_right = 0.0
            anchor_bottom = 1.0
        WindowAnchor.BOTTOM_RIGHT:
            anchor_left = 1.0
            anchor_top = 1.0
            anchor_right = 1.0
            anchor_bottom = 1.0

    # Update the growth direction and offsets
    grow_horizontal = Control.GROW_DIRECTION_END if WINDOW_ANCHOR in [WindowAnchor.TOP_LEFT, WindowAnchor.BOTTOM_LEFT] else Control.GROW_DIRECTION_BEGIN
    grow_vertical = Control.GROW_DIRECTION_END if WINDOW_ANCHOR in [WindowAnchor.TOP_LEFT, WindowAnchor.TOP_RIGHT] else Control.GROW_DIRECTION_BEGIN

    offset_left = 0.0
    offset_right = 0.0
    offset_top = 0.0
    offset_bottom = 0.0