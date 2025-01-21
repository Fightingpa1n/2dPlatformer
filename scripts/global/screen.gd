extends Node

@onready var camera:Camera2D = await NodeManager.get_camera() #get the camera

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