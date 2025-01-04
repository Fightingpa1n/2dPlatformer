@tool
extends VBoxContainer
class_name DebugContainer

@export var EXPANDED:bool = false:
    set(value):
        EXPANDED = value
        _update()

@export var TITLE:String = "":
    set(value):
        TITLE = value
        _update()

var toggle_button:Button
var expand_ico:Texture = preload("../assets/expand.svg")
var collapse_ico:Texture = preload("../assets/collapse.svg")

func _enter_tree():
    toggle_button = Button.new()
    toggle_button.text = TITLE
    toggle_button.icon = expand_ico
    toggle_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
    toggle_button.size_flags_horizontal = SIZE_FILL | SIZE_SHRINK_END
    toggle_button.custom_minimum_size = Vector2(20, 20)
    toggle_button.toggle_mode = false
    toggle_button.connect("on_expand", _toggle_expand)
    add_child(toggle_button, false, INTERNAL_MODE_FRONT)
    _update()

func _update():
    toggle_button.text = TITLE
    toggle_button.icon = expand_ico if EXPANDED else collapse_ico #set icon

    for child in get_children():
        if child != toggle_button:
            child.visible = EXPANDED

func _toggle_expand():
    EXPANDED = !EXPANDED
    _update()
