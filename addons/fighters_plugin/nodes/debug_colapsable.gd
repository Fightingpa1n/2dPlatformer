@tool
extends DebugContainer
class_name DebugColapsable

@export var EXPANDED: bool = false:
	set(value):
		EXPANDED = value
		_update()

@export var TITLE: String = "":
	set(value):
		TITLE = value
		_update()

var toggle_button: Button
var expand_ico: Texture = preload("../assets/expand.svg")
var collapse_ico: Texture = preload("../assets/collapse.svg")

func _ready():
	# Ensure the button is set up when the node enters the scene
	_setup_button()
	_update()

func _setup_button():
	if not toggle_button:
		toggle_button = Button.new()
		toggle_button.text = TITLE
		toggle_button.icon = expand_ico
		toggle_button.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
		toggle_button.size_flags_horizontal = SIZE_FILL | SIZE_SHRINK_END
		toggle_button.custom_minimum_size = Vector2(20, 20)
		toggle_button.toggle_mode = false
		toggle_button.focus_mode = Control.FOCUS_NONE # Disable focus
		toggle_button.connect("pressed", _toggle_expand) # Correct signal
		add_child(toggle_button, false, INTERNAL_MODE_FRONT)
func _update():
	# Update button text and icon
	toggle_button.text = TITLE
	toggle_button.icon = collapse_ico if EXPANDED else expand_ico

	# Show or hide child nodes based on EXPANDED
	for child in get_children():
		if child != toggle_button:
			child.visible = EXPANDED

func _toggle_expand():
	# Toggle the EXPANDED state and update
	EXPANDED = not EXPANDED
	_update()
