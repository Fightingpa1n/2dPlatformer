@tool
extends PanelContainer
class_name DebugWindow

enum AnchorPoint{TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}

var PRESETS = {
	AnchorPoint.TOP_LEFT: {
		'anchor_left': 0.0,
		'anchor_top': 0.0,
		'anchor_right': 0.0,
		'anchor_bottom': 0.0,
		'grow_horizontal': Control.GROW_DIRECTION_END,
		'grow_vertical': Control.GROW_DIRECTION_END,
	},
	AnchorPoint.TOP_RIGHT: {
		'anchor_left': 1.0,
		'anchor_top': 0.0,
		'anchor_right': 1.0,
		'anchor_bottom': 0.0,
		'grow_horizontal': Control.GROW_DIRECTION_BEGIN,
		'grow_vertical': Control.GROW_DIRECTION_END,
	},
	AnchorPoint.BOTTOM_LEFT: {
		'anchor_left': 0.0,
		'anchor_top': 1.0,
		'anchor_right': 0.0,
		'anchor_bottom': 1.0,
		'grow_horizontal': Control.GROW_DIRECTION_END,
		'grow_vertical': Control.GROW_DIRECTION_BEGIN,
	},
	AnchorPoint.BOTTOM_RIGHT: {
		'anchor_left': 1.0,
		'anchor_top': 1.0,
		'anchor_right': 1.0,
		'anchor_bottom': 1.0,
		'grow_horizontal': Control.GROW_DIRECTION_BEGIN,
		'grow_vertical': Control.GROW_DIRECTION_BEGIN,
	},
}

#=========================== Editor ===========================#
@export var show_window:bool = true: #if the window should be shown
	set(value):
		show_window = value
		_editor_update()

@export var anchor_point:AnchorPoint = AnchorPoint.TOP_LEFT: #the anchor point of the window
	set(value):
		anchor_point = value
		_editor_update()
	
@export var window_height:Vector2 = Vector2(200, 200): #the size of the window
	set(value):
		window_height = value
		_editor_update()


# @onready var debug_root:DebugRoot = get_parent() #the root container of the debug window
# @onready var _window_container:DebugContainer = get_child(0) #the window container

var values = {} #the values dictionary

func _on_values_updated(): #called when the values are updated
	print("Updting values")
	# values = _window_container.get_values() #get the values from the window container


func _editor_update(): #update self on changes in editor (used for display changes when stuff in the editor changes aka it's not running yet)
	visible = show_window #set the visibility of the window
	
	custom_minimum_size = window_height #set the size of the window

	anchor_left = PRESETS[anchor_point]['anchor_left']
	anchor_top = PRESETS[anchor_point]['anchor_top']
	anchor_right = PRESETS[anchor_point]['anchor_right']
	anchor_bottom = PRESETS[anchor_point]['anchor_bottom']

	grow_horizontal = PRESETS[anchor_point]['grow_horizontal']
	grow_vertical = PRESETS[anchor_point]['grow_vertical']

	offset_left = 0.0
	offset_right = 0.0
	offset_top = 0.0
	offset_bottom = 0.0

	# _window_container.get_values() #update the values   
