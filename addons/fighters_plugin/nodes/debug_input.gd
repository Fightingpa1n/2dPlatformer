@tool
extends Control
class_name DebugInput

func get_debug(): #get the debug root
    var found_debug = false
    var parent = get_parent()
    while not found_debug:
        if parent is DebugRoot: return parent #return the debug root if found

        if parent == null:
            printerr("Could not find DebugRoot")
            return null
        else:
            parent = parent.get_parent()

func get_debug_window(): #get the debug window
    var found_debug = false
    var parent = get_parent()
    while not found_debug:
        if parent is DebugWindow: return parent #return the debug window if found

        if parent == null:
            printerr("Could not find DebugWindow")
            return null
        else:
            parent = parent.get_parent()
