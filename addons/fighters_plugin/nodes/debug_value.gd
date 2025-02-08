@tool
extends Label
class_name DebugValue

enum targetNode{
    PLAYER
}

var value ## the value we want to display

@export var label:String = "Value": ## the label of the debug value
    set(_value):
        label = _value
        _update_editor()

@export var default_value = 0: ## the default value
    set(_value):
        value = _value
        default_value = _value
        _update_editor()

@export var target:targetNode = targetNode.PLAYER: ## the target node
    set(_value):
        target = _value
        _update_editor()

@export var target_signal:String = "value_changed": ## the target signal
    set(_value):
        target_signal = _value
        _update_editor()

func _ready():    
    var node
    match target: #get target node
        targetNode.PLAYER:
            node = await NodeManager.get_player()
    
    if not node:
        printerr("No target node found")
        return
    node.connect(target_signal, _on_value_change)
    _update_editor()
    
func _update_editor(): ## update the editor
    if not value: value = default_value #use default
    text = label + ": " + str(value) #update display

func _on_value_change(_value): ## the thing we want to connect the signal to
    value = _value
    _update_editor()


