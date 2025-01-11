@tool
extends VBoxContainer
class_name DebugContainer

var debug_root:DebugRoot
var debug_window:DebugWindow

var key:String #the key of the container

#================= Public =================#
func _enter_tree():
    var parent = get_parent() #get the parent
    if parent is DebugContainer:
        debug_root = parent.debug_root
        debug_window = parent.debug_window
    elif parent is DebugWindow:
        debug_root = parent.debug_root
        debug_window = parent
    else:
        printerr("DebugContainer: Unknown parent type: "+str(parent))


func _ready():
    if has_key(): name = key #set name to key if we have a key


func has_key(): #check if the container has a key
    if key and key != "": return true
    else: return false

func get_values() -> Dictionary:
    var values = {} #init the values dictionary
    for child in get_children(): #loop through the children
        
        if child is DebugContainer: #if the child is a container
            if child.has_key(): #if the container has a key add a sub dict
                values[child.get_key()] = child.get_values() #add the sub dict to the values dictionary
            else: #if the container has no key add it to the values directly
                values += child.get_values() #add the child's values to the values dictionary
        
        elif is_debug_input(child):
            values[child.key] = child.value #add the value to the values dictionary

    return values #return the values dictionary


func is_debug_input(node:Node) -> bool: #check if a node is a debug input node
    if node is DebugCheckbox: return true
    return false


#================= Add Stuff =================#
#containers
func add_container(key:String="") -> DebugContainer: #add a container
    var container = DebugContainer.new() #init the container
    container.key = key #set the key
    add_child(container) #add the container to the container
    return container #return the container

func add_colapsable(key:String="", label:String="", expanded:bool=false) -> DebugColapsable: #add a colapsable
    var colapsable = DebugColapsable.new() #init the colapsable
    colapsable.key = key
    colapsable.title = label
    colapsable.expanded = expanded
    add_child(colapsable) #add the colapsable to the container
    return colapsable #return the colapsable

#inputs
func add_checkbox(key:String="", label:String="Checkbox", value:bool=false) -> DebugCheckbox: #add a checkbox
    var checkbox = DebugCheckbox.new() #init the checkbox
    checkbox.key = key #set the key
    checkbox.label = label #set the label
    checkbox.value = value #set the value
    add_child(checkbox) #add the checkbox to the container
    return checkbox #return the checkbox
    