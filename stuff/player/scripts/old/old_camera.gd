extends Camera2D

@export_category("General")
@export_node_path var target

# Zoom
@export_category("Zoom")
@export var MIN_ZOOM : float = 0.5
@export var MAX_ZOOM : float = 5
@export var ZOOM_SPEED : float = 0.1
@export var DEFAULT_ZOOM : float = 1.0

# Drag
@export_category("Offset")
@export var MAX_OFFSET : int = 10


#private
var player
var og_mousePos : Vector2
var dragOffset : Vector2

func _ready():
	
	#set values
	#player = get_node(target)
	if player == null:
		print("Camera2D: Target not found")
		return
	og_mousePos = Vector2(0,0)
	dragOffset = Vector2(0,0)

	#apply default zoom
	DEFAULT_ZOOM = clamp(DEFAULT_ZOOM, MIN_ZOOM, MAX_ZOOM) #clamp
	set_zoom(Vector2(DEFAULT_ZOOM, DEFAULT_ZOOM))

func _physics_process(_delta):

	if player == null:
		return
	
	var playerPos = player.get_global_transform().origin
	#camera movement
	if Input.is_action_pressed("camera"):
		
		#zoom
		if Input.is_action_just_released("scroll_up"):
			var new_zoom = clamp(zoom.x + ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			zoom = Vector2(new_zoom, new_zoom)
		if Input.is_action_just_released("scroll_down"):
			var new_zoom = clamp(zoom.x - ZOOM_SPEED, MIN_ZOOM, MAX_ZOOM)
			zoom = Vector2(new_zoom, new_zoom)

		#drag
		if Input.is_action_pressed("drag"):

			#on frame of mouse down
			if Input.is_action_just_pressed("drag"):
				og_mousePos = get_viewport().get_mouse_position() + offset * zoom
				
			#while dragging
			var current_mousePos = get_viewport().get_mouse_position() 
			var targetOffset = (og_mousePos - current_mousePos) / zoom 
			dragOffset = Vector2(clamp(targetOffset.x, -MAX_OFFSET, MAX_OFFSET), clamp(targetOffset.y, -MAX_OFFSET, MAX_OFFSET)) #clamp
			

			offset = dragOffset

		#reset camera
		if Input.is_action_just_released("reset"):
			offset = Vector2(0,0)
			zoom = Vector2(DEFAULT_ZOOM, DEFAULT_ZOOM)

	#follow player
	global_position = playerPos
