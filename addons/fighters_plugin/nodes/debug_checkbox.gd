@tool
extends CheckBox
class_name DebugCheckbox

signal value_changed

var _key:String #the key that will be used to access the value
var _label:String #the label of the checkbox (the text next to the checkbox used to describe it or name it in the ui)
var _value:bool #the value of the checkbox (if checked or not)

func _enter_tree(): #usage check
    if not get_parent() is DebugContainer:
        printerr("DebugCheckbox: Parent is not DebugContainer")   

@onready var debug_window = get_parent().debug_window


func _init(key:String, label:String, value:bool) -> void:
    _key = key
    _label = label
    _value = value

func _ready():
    name = _key
    text = _label
    button_pressed = _value
    
    focus_mode = Control.FOCUS_NONE #disable focus
    connect("toggled", _checkbox_toggle)

func _checkbox_toggle(pressed:bool) -> void:
    _value = pressed
    emit_signal("value_changed")


func get_key() -> String: return _key #get the key
func get_value() -> bool: return _value #get the value


