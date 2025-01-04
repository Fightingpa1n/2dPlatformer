extends Node

var camera:Camera2D #the camera

signal clicked_on_screen(Vector2) #signal for when the screen is clicked

func _ready() -> void:
	camera = await NodeManager.get_camera() #get the camera

func _input(event):
	var scroll = 0
	if Input.is_action_pressed("zoom_in"):
		scroll = 0.1
	if Input.is_action_pressed("zoom_out"):
		scroll = -0.1

	if scroll != 0:
		#okay so the zoom is a vector2, but the x and y are the same, so that doesn't matter to us in here.
		#but there are some rules, the zoom value can't be 0, but it can be negativ. even though that doesn't make a difference really.
		#so let's say the default zoom is 1, with scrolling we adjust the value by 0.1, and the minumum value is 0.1 and the maximum value is 5
		var zoom_value = clamp(camera.zoom.x + scroll, 0.1, 5)
		camera.zoom = Vector2(zoom_value, zoom_value)

	if Input.is_action_just_pressed("reset"):
		camera.zoom = Vector2(1,1)

#================ Screen Functions (Position related) ================#
func screen_to_world(screen_pos:Vector2) -> Vector2: #returns the world position of a given screen position
	var centered_screen_pos = _screen_coordinates(screen_pos) #convert the position to screen coordinates
	var camera_pos = camera.global_position #get the camera position in the world
	var pos_diff = centered_screen_pos / camera.zoom #get the difference between the screen position and the camera position
	var world_pos = camera_pos + pos_diff #get the world position
	return world_pos

func world_to_screen(world_pos:Vector2) -> Vector2: #returns the screen position of a given world position
	
	#first of we want the camera position in the world
	var camera_pos = camera.global_position #get the camera position in the world

	#now we want the difference between the given postion in the world and the camera position
	var pos_diff = (world_pos - camera_pos) * camera.zoom #get the difference between the world position and the camera position

	#now since the camera is in the center of the screen, we need to convert it to screen coordinates so we can draw it accauratly
	var screen_pos = _centered(pos_diff) #convert the position to screen coordinates

	return screen_pos


#================ Screen Functions (Rect related) ================#
func get_screen_size(): #get the screen size
	return camera.get_viewport_rect().size

func get_camera_view_size(): #get the camera view size (like the size of what the camera can see) #NOTE: maybe in the futre move this function into the camera script
	return camera.get_viewport_rect().size / camera.zoom

func get_mouse_position(): #get the mouse position in the world
	return _centered(get_viewport().get_mouse_position())

func get_global_mouse_position(): #get the mouse position in the world
	return 

#================ Private Functions ================#
func _centered(screen_pos:Vector2) -> Vector2: #adjust a screen position so 0,0 is the center of the screen
	return screen_pos + (get_screen_size() / 2)

func _screen_coordinates(centered_screen_pos:Vector2) -> Vector2: #adjust a centered screen position so 0,0 is the top left of the scree
	return centered_screen_pos - get_screen_size() / 2