@tool
extends Label
class_name DebugValue

enum ValueType {STRING, INT, FLOAT, BOOL, VECTOR2, VECTOR3}

@export var LABEL:String = "Value":
    set(value):
        LABEL = value
        _update()

@export var KEY:String = "value_key":
    set(value):
        KEY = _key(value)
        _update()

@export var VALUE_TYPE:ValueType = ValueType.STRING:
    set(value):
        VALUE_TYPE = value
        _update()

var _label:String = ""

func _ready():
    _update()

func _key(name) -> String:
    return name.to_lower().replace(" ", "_")

func _update():
    name=KEY
    _label = LABEL + ": " #set label
    match VALUE_TYPE:
        ValueType.STRING:
            text = _label + "string"
        ValueType.INT:
            text = _label + "int"
        ValueType.FLOAT:
            text = _label + "float"
        ValueType.BOOL:
            text = _label+ "bool"
        ValueType.VECTOR2:
            text = _label+"vector2"
        ValueType.VECTOR3:
            text = _label+"vector3"

func update(value, debug_settings): 
    text = _label + str(value)

func set_value(value): #set the value
    update(value, null)

#also if you want to change the value you can 