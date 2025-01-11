@tool
extends CheckBox
class_name DebugCheckbox

signal value_changed

var key:String #the key that will be used to access the value
var label:String = "Checkbox" #the label of the checkbox (the text next to the checkbox used to describe it or name it in the ui)
var value:bool = false #the value of the checkbox (if checked or not)

func _enter_tree(): #usage check
    if not get_parent() is DebugContainer:
        printerr("DebugCheckbox: Parent is not DebugContainer")

@onready var debug_window = get_parent().debug_window

func _ready():
    if not key or key == "": key = label.to_lower().replace(" ", "_") #genrate key if not given
    name = key
    text = label

    focus_mode = Control.FOCUS_NONE #disable focus
    connect("toggled", _checkbox_toggle)
    connect("value_changed", debug_window._on_values_updated)

func _checkbox_toggle(pressed:bool) -> void: #called when the checkbox is toggled
    value = pressed
    emit_signal("value_changed")


