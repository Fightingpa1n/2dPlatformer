@tool
extends VBoxContainer
class_name DebugContainer

var debug_root:DebugRoot
var debug_window:DebugWindow
var parent_container:DebugContainer

var _key:String #the key of the container

func _keyify(name:String) -> String: #private function to convert a name to a key
    return name.to_lower().replace(" ", "_")

#================= Public =================#
func _init(key:String="") -> void: #init the container
    if key != "": _key = key #set the key if given

    var parent = get_parent() #get the parent
    if parent is DebugWindow: #if parent is DebugWindow (aka this is the window root container)
        debug_root = parent.debug_root #set the debug_root
        debug_window = parent #set the debug_window
    elif parent is DebugContainer: #if parent is DebugContainer (aka this is a child container)
        debug_root = parent.debug_root #set the debug_root
        debug_window = parent.debug_window #set the debug_window
        parent_container = parent #set the parent_container

    else: #unknown parent
        printerr("DebugContainer: Unknown parent type: " + str(parent))


func _ready():
    if _key: name = _key #set the name to the key if it exists


func has_key(): #check if the container has a key
    if _key and _key != "": return true
    else: return false

func get_key(): return _key #get the key

func get_values() -> Dictionary:
    var values = {} #init the values dictionary
    for child in get_children(): #loop through the children
        
        if child is DebugContainer: #if the child is a container
            if child.has_key(): #if the container has a key add a sub dict
                values[child.get_key()] = child.get_values() #add the sub dict to the values dictionary
            else: #if the container has no key add it to the values directly
                values += child.get_values() #add the child's values to the values dictionary
        
        elif is_debug_input(child):
            values[child.get_key()] = child.get_value() #add the value to the values dictionary

    return values #return the values dictionary


func is_debug_input(node:Node) -> bool: #check if a node is a debug input node
    if node is DebugCheckbox: return true
    return false


#================= Add Stuff =================#
#containers
func add_container(key:String="") -> void:
    var container = DebugContainer.new(key) #init the container
    add_child(container) #add the container to the container

func add_colapsable(key:String="", label:String="", expanded:bool=false) -> void:
    var colapsable = DebugColapsable.new(key, label, expanded) #init the colapsable
    add_child(colapsable) #add the colapsable to the container

#inputs
func add_checkbox(key:String="", label:String="Checkbox", value:bool=false) -> void:
    key = _keyify(label) if key == "" else _keyify(key) #if no key given use the label
    var checkbox = DebugCheckbox.new(key, label, value) #init the checkbox
    checkbox.connect("value_changed", debug_window._on_values_updated()) #connect the value_changed signal to the window's values_updated signal
    add_child(checkbox) #add the checkbox to the container
    