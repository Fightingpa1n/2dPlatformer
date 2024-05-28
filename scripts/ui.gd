extends CanvasLayer

#the ui script as a whole

var debug_ui

func _ready():
	debug_ui = %debug_ui


func update_debug_ui(current_state, velocity, movement_velocity, other_velocity, whole_velocity):
	debug_ui.update_debug_ui(current_state, velocity, movement_velocity, other_velocity, whole_velocity)