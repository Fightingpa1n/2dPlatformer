extends Control

#this is the player's debug script, it contains all the debug functions and stores debug values
#it will create a gui on creation and display values in there!

#=== stuff ===#
var player:CharacterBody2D #the player reference
var camera:Camera2D #the camera reference
var debug:Control #the debug gui

#=== debug_ui elements ===#
@onready var debug_settings = $container/scroll/flex/container/debug_settings
@onready var state_container = $container/scroll/flex/container/states
@onready var velocity_container = $container/scroll/flex/container/velocity

#=== debug Settings ===#
var debug_advanced:bool = false #draw advanced debug stuff #TODO: implement

var velocity_absolute:bool = false #if velocity should be displayed as absolute values
var velocity_combine:bool = false #if velocity should be combined into one value
var velocity_round:bool = false #if velocity should be rounded
var velocity_shorten:bool = false #if velocity should be shortened

#=== player vars ===#
var player_state_name:String = ""

var player_velocity:Vector2 = Vector2()
var player_movement_velocity:Vector2 = Vector2()
var player_other_velocity:Vector2 = Vector2()
var player_total_velocity:Vector2 = Vector2()

#=== drawing vars ===#
var direction_draw:bool = false
var direction_draw_target:Vector2 = Vector2()

var point_draw:bool = false
var point_draw_relative:bool = false
var point_draw_target:Vector2 = Vector2()

func _ready() -> void:
	player = await NodeManager.get_player()
	camera = await NodeManager.get_camera()
	debug = camera.get_node("debug")

	#connect to player signals
	player.connect("state_change", update_state)
	player.connect("velocity_update", update_velocity)
	#TODO: the PreProcessVelocityUpdate signal is currently not used

	#connect to ui signals
	debug_settings.get_node("advanced").connect("pressed", _debug_settings_update)
	debug_settings.get_node("draw_debug").connect("pressed", _debug_settings_update)
	debug_settings.get_node("reset_direction").connect("pressed", reset_direction_target)
	debug_settings.get_node("reset_point").connect("pressed", reset_point_target)
	_debug_settings_update()

	velocity_container.get_node("velocity_settings/absolute").connect("pressed", _velocity_settings_update)
	velocity_container.get_node("velocity_settings/combined").connect("pressed", _velocity_settings_update)
	velocity_container.get_node("velocity_settings/round").connect("pressed", _velocity_settings_update)
	velocity_container.get_node("velocity_settings/shorten").connect("pressed", _velocity_settings_update)
	_velocity_settings_update()

#================ Debug =================#
func set_direction_target(direction:Vector2) -> void:
	direction_draw = true
	direction_draw_target = direction

func reset_direction_target() -> void:
	direction_draw = false
	direction_draw_target = Vector2()

func set_point_target(target:Vector2, relative:bool = false) -> void:
	point_draw = true
	point_draw_target = target
	point_draw_relative = relative

func reset_point_target() -> void:
	point_draw = false
	point_draw_target = Vector2()
	point_draw_relative = false


func _get_position(target_position:Vector2) -> Vector2:
	var relative_camera_position = -position + Vector2(get_viewport().size.x/2, get_viewport().size.y/2) #get relative camera position
	var relative_position = target_position - camera.global_position #get difference between global camera pos and the given position
	return relative_camera_position + relative_position #return the diffence in relation to the relative camera pos


func _debug_settings_update():
	debug.should_draw = debug_settings.get_node("draw_debug").button_pressed
	debug_advanced = debug_settings.get_node("advanced").button_pressed
	queue_redraw()

#================ State =================#
func update_state(state_name:String) -> void:
	player_state_name = state_name
	_update_state()

func _update_state():
	state_container.get_node("current").text = "State: "+player_state_name

#================ Velocity =================#
func update_velocity(velocity:Vector2, movement_velocity:Vector2, other_velocity:Vector2) -> void:
	player_velocity = velocity
	player_movement_velocity = movement_velocity
	player_other_velocity = other_velocity
	player_total_velocity = velocity + movement_velocity + other_velocity
	_update_velocity()

func _update_velocity():
	var velocities = {
		"velocity": {"title": "%v: ", "v":player_velocity},
		"move": {"title": "Move %v: ", "v":player_movement_velocity},
		"other": {"title": "Other %v: ", "v":player_other_velocity},
		"total": {"title": "Total %v: ", "v":player_total_velocity}
	}
	for key in velocities.keys(): #apply settings
		velocities[key]["v"] = velocities[key]["v"].abs() if velocity_absolute else velocities[key]["v"]
		velocities[key]["v"] = velocities[key]["v"].round() if velocity_round else velocities[key]["v"]
		velocities[key]["v"] = "x: "+str(velocities[key]["v"].x)+" |y: "+str(velocities[key]["v"].y)
		velocities[key]["title"] = velocities[key]["title"].replace("%v", "V" if velocity_shorten else "Velocity")

	if velocity_combine: #if combined
		velocity_container.get_node("total").text = velocities["velocity"]["title"]+velocities["total"]["v"]
	else:
		for key in velocities.keys():
			velocity_container.get_node(key).text = velocities[key]["title"]+velocities[key]["v"]

func _velocity_settings_update():
	velocity_absolute = velocity_container.get_node("velocity_settings/absolute").button_pressed
	velocity_combine = velocity_container.get_node("velocity_settings/combined").button_pressed
	velocity_round = velocity_container.get_node("velocity_settings/round").button_pressed
	velocity_shorten = velocity_container.get_node("velocity_settings/shorten").button_pressed

	if velocity_combine:
		velocity_container.get_node("velocity").hide()
		velocity_container.get_node("move").hide()
		velocity_container.get_node("other").hide()
	else:
		velocity_container.get_node("velocity").show()
		velocity_container.get_node("move").show()
		velocity_container.get_node("other").show()
	_update_velocity()
