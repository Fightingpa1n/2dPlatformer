@tool
extends Label
class_name DebugValue

enum ValueType {STRING, INT, FLOAT, BOOL, VECTOR2, VECTOR3}

@onready var debug_window = get_parent().debug_window

var type:ValueType = ValueType.STRING

var label:String = "Value:"
var key:String = ""
var value:Variant = null

func _enter_tree():
    if not get_parent() is DebugContainer: #check if the parent is a debug container
        printerr("DebugValue: Parent is not DebugContainer")

func _ready():
    if not key or key == "": key = label.to_lower().replace(" ", "_")
    name = key
    _editor_update()

func _editor_update(): #update self on changes in editor (used for display changes when stuff in the editor changes aka it's not running yet)
    match type: #set default value
        ValueType.STRING:
            value = ""
        ValueType.INT:
            value = 0
        ValueType.FLOAT:
            value = 0.0
        ValueType.BOOL:
            value = false
        ValueType.VECTOR2:
            value = Vector2()
        ValueType.VECTOR3:
            value = Vector3()
    _value_update()

func _value_update(): #update text to display current value (used pretty much the whole time)
    text = label + " " + str(value)

func update_value(value): #update the value
    self.value = value
    _value_update()

#the update value function can be overriden to add custom value handling

