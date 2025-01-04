extends Control

#this is the debug Draw script, it's a child of the camera and is for drawing debug stuff on the screen
var should_draw:bool

var screen_points:Array = [] #points
var world_points:Array = [] #points

func draw_point(_pos, _color, _size=5, _time=5.0) -> void: #draw a point on the screen
	# _pos: the position of the point on the screen (screen coordinates)
	# _color: the color of the point
	# _size: the size of the point
	# _time: the time the point will be drawn for, if set to -1, the point will be drawn forever
	screen_points.append([_pos, _color, _size, _time])

func draw_world_point(_pos, _color, _size=5, _time=5.0) -> void: #draw a point on the screen
	# _pos: the position of the point in the world
	# _color: the color of the point
	# _size: the size of the point
	# _time: the time the point will be drawn for, if set to -1, the point will be drawn forever
	world_points.append([_pos, _color, _size, _time])

func _process(delta):
	for point in screen_points: #for each point
		if point[3] == -1: continue #if time is set to -1, then the point will be drawn forever
		point[3] = max(0, point[3] - delta) #decrease the time
		if point[3] == 0: #if the time is 0
			screen_points.erase(point) #remove the point

	for point in world_points: #for each point
		if point[3] == -1: continue #if time is set to -1, then the point will be drawn forever
		point[3] = max(0, point[3] - delta) #decrease the time
		if point[3] == 0: #if the time is 0
			world_points.erase(point) #remove the point

	queue_redraw() #redraw

func _draw():
	if not should_draw: return #if we shouldn't draw, then return

	for point in screen_points: #for each point
		draw_circle(_fix(point[0]), point[2], point[1]) #draw the point

	for point in world_points: #for each point
		draw_circle(_fix(Screen.world_to_screen(point[0])), point[2], point[1]) #draw the point
	
	var world_center = Screen.world_to_screen(Vector2(0, 0)) #get the center of the world in screen coordinates
	draw_circle(_fix(world_center), 5, Color(0, 1, 0, 1)) #draw the center of the world


func _fix(_pos:Vector2) -> Vector2: #fix the position (so it's a screen position and it takes the camera zoom into account)
	_pos = _pos - get_viewport_rect().size / 2
	return _pos / get_parent().zoom
