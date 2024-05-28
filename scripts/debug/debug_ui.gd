extends Control

@onready var lbl_current_state: Label = %current_state
@onready var lbl_velocity: Label = %velocity
@onready var lbl_movement_velocity: Label = %movement_velocity
@onready var lbl_other_velocity: Label = %other_velocity
@onready var lbl_whole_velocity: Label = %whole_velocity

func update_debug_ui(current_state, velocity, movement_velocity, other_velocity, whole_velocity):
	lbl_current_state.text = "Current State: " + current_state
	lbl_velocity.text = "Velocity: " + str(velocity)
	lbl_movement_velocity.text = "Movement Velocity: " + str(movement_velocity)
	lbl_other_velocity.text = "Other Velocity: " + str(other_velocity)
	lbl_whole_velocity.text = "Whole Velocity: " + str(whole_velocity)

