extends Node

var debug:Control #the main debug node

#============= debug_window elements =============#
#======== player ========#
@onready var player_current_state = $container/scroll/flex/container/player/states/current
@onready var player_velocity = $container/scroll/flex/container/player/velocity/velocity
@onready var player_move_velocity = $container/scroll/flex/container/player/velocity/move
@onready var player_other_velocity = $container/scroll/flex/container/player/velocity/other
@onready var player_total_velocity = $container/scroll/flex/container/player/velocity/total

#=== settings ===#
@onready var stngs_player_simple_velocity = $container/scroll/flex/container/player/player_settings/simple
@onready var stngs_player_absolute_velocity = $container/scroll/flex/container/player/player_settings/absolute
@onready var stngs_player_shorten_velocity = $container/scroll/flex/container/player/player_settings/shorten

#======== debug ========#
#=== settings ===#
#@onready var stngs_advanced = $container/scroll/flex/container/debug_settings/advanced
@onready var stngs_debug_draw = $container/scroll/flex/container/debug_settings/draw

#=== drawing settings ===#
@onready var stngs_draw_world = $container/scroll/flex/container/debug_settings/draw_settings/world




func _ready() -> void:
	debug = await NodeManager.get_debug()
	#Player stuff














# func _update_velocity():
# 	var velocities = {
# 		"velocity": {"title": "%v: ", "v":player_velocity},
# 		"move": {"title": "Move %v: ", "v":player_movement_velocity},
# 		"other": {"title": "Other %v: ", "v":player_other_velocity},
# 		"total": {"title": "Total %v: ", "v":player_total_velocity}
# 	}
# 	for key in velocities.keys(): #apply settings
# 		velocities[key]["v"] = velocities[key]["v"].abs() if velocity_absolute else velocities[key]["v"]
# 		velocities[key]["v"] = velocities[key]["v"].round() if velocity_round else velocities[key]["v"]
# 		velocities[key]["v"] = "x: "+str(velocities[key]["v"].x)+" |y: "+str(velocities[key]["v"].y)
# 		velocities[key]["title"] = velocities[key]["title"].replace("%v", "V" if velocity_shorten else "Velocity")

# 	if velocity_combine: #if combined
# 		velocity_container.get_node("total").text = velocities["velocity"]["title"]+velocities["total"]["v"]
# 	else:
# 		for key in velocities.keys():
# 			velocity_container.get_node(key).text = velocities[key]["title"]+velocities[key]["v"]


# func _stngs_player_update() -> void:
# 	velocity_absolute = velocity_container.get_node("velocity_settings/absolute").button_pressed
# 	velocity_combine = velocity_container.get_node("velocity_settings/combined").button_pressed
# 	velocity_round = velocity_container.get_node("velocity_settings/round").button_pressed
# 	velocity_shorten = velocity_container.get_node("velocity_settings/shorten").button_pressed

# 	if velocity_combine:
# 		velocity_container.get_node("velocity").hide()
# 		velocity_container.get_node("move").hide()
# 		velocity_container.get_node("other").hide()
# 	else:
# 		velocity_container.get_node("velocity").show()
# 		velocity_container.get_node("move").show()
# 		velocity_container.get_node("other").show()
# 	_update_velocity()


