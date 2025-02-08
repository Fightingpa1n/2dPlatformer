@tool
extends VBoxContainer
class_name DebugColapsable

var title:String
var expanded:bool

@export var start_expanded:bool = false:
	set(value):
		start_expanded = value
		expanded = value
		_update()

var _toggle_button:Button
var expand_ico:Texture = preload("../assets/expand.svg")
var collapse_ico:Texture = preload("../assets/collapse.svg")
var button_size:float = 20

func _ready():
	_update()

func _button_setup():
	if _toggle_button: return #return if exists

	#Create the toggle button
	_toggle_button = Button.new()
	_toggle_button.text = title
	_toggle_button.icon = expand_ico
	_toggle_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_toggle_button.size_flags_horizontal = SIZE_FILL | SIZE_SHRINK_END
	_toggle_button.custom_minimum_size = Vector2(button_size, button_size)
	_toggle_button.toggle_mode = false
	_toggle_button.focus_mode = Control.FOCUS_NONE # Disable focus
	_toggle_button.connect("pressed", _toggle_expand) # Correct signal
	add_child(_toggle_button, false, INTERNAL_MODE_FRONT)


func _update():
	# Update button text and icon
	_button_setup()
	_toggle_button.text = title
	_toggle_button.icon = collapse_ico if expanded else expand_ico

	# Show or hide child nodes based on expanded
	for child in get_children():
		if child != _toggle_button:
			child.visible = expanded

func _toggle_expand():
	# Toggle the EXPANDED state and update
	expanded = not expanded
	_update()
