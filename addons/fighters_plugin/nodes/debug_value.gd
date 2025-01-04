@tool
extends Label
class_name DebugValue

enum ValueType {STRING, INT, FLOAT, BOOL, VECTOR2, VECTOR3}

@export var NAME:String = "":
    set(value):
        NAME = value
        _update()

@export var VALUE_TYPE:ValueType = ValueType.STRING:
    set(value):
        VALUE_TYPE = value
        _update()

var label:String = ""
var value
var _alteration:Callable

func _enter_tree():
    _update()

func _update():
    label = NAME + ": " #set label
    match VALUE_TYPE:
        ValueType.STRING:
            text = label + "string"
        ValueType.INT:
            text = label + "int"
        ValueType.FLOAT:
            text = label + "float"
        ValueType.BOOL:
            text = label+ "bool"
        ValueType.VECTOR2:
            text = label+"vector2"
        ValueType.VECTOR3:
            text = label+"vector3"

func update(value):
    value = _alteration.call(value) if _alteration else value
    text = label + str(value)

func alter(alteration:Callable):
    _alteration = alteration
