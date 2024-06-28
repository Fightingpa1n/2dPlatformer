extends CharacterBody2D

#DONE: move left and right
#DONE: gravity
#DONE: jump
#DONE: double jump
#DONE: coyote time
#DONE: wall slide
#DONE: better wall slide
#DONE: jump buffer
#DONE: change the way is_walled works to make it more fun and consistent
#DONE: better air controll (I will see if it needs some tweaking after adding the other movement mechanics to make it feel better in tandem with them)

#TODO: dash towards the mouse cursor
#TODO: running (either by going into a direction for long enough like in terraria or when entering the ground with a velocity greater or equal to the running speed)
#TODO: slamming (when in the air, press down to fall faster and jump higher when jumping immediately after slamming into the ground)
#TODO: make better debug stuff (to better display and change values during playtests)
#TODO: add logic to specify if a surface is safe to land on (for bufferjumps)

#TODO: Wall jump buffer (maybe)
#TODO: grapling hook (maybe) (pretty unlikly since It would need some tweaks to fit in with the idea of the game but it would be really cool)
#TODO: crouching (maybe) (if so, also add sliding, rolling, and modify jump when done from crouching)
#TODO: Swimming (maybe) (if I make water stuff atleast)
#TODO: ledge grab (maybe) (when falling, grab onto a ledge if the player is close enough to it)

# Values
@export_category("Values")
@export var SPEED = 300.0 #speed on the ground
@export var ACCELERATION = 3600.0 #acceleration on the ground
@export var DECELERATION = 3600.0 #deceleration on the ground

@export var AIR_SPEED = 300.0 #speed in the air
@export var AIR_ACCELERATION = 3200.0 #acceleration in the air
@export var AIR_DECELERATION = 3200.0 #deceleration in the air

@export var JUMP_FORCE = 400.0 #force applied when jumping
@export var WALL_JUMP_FORCE = 800.0 #force applied when wall jumping
@export var WALL_JUMP_FORCE_BAD = 500.0 #force applied when wall jumping while not having walljump unlocked
@export var MIN_JUMP_TIME = 0.1 #the amount of time jump force is applied for the minimum jump (minimum jump is the jump button is only tapped)
@export var MAX_JUMP_TIME = 0.5 #the amount of time the jump button can be held down after the minimum jump time to apply more force
@export var WALL_SLIDE_SPEED_SLOW = 25.0 #the speed the player slides down a wall when pressing up
@export var WALL_SLIDE_SPEED_NORMAL = 50.0 #the speed the player slides down a wall
@export var WALL_SLIDE_SPEED_FAST = 100.0 #the speed the player slides down a wall when pressing down 
@export var COYOTE_TIME = 0.1 #the amount of time after leaving the ground+ that the player can still jump

@export var DASH_FORCE = 1000.0 #the force applied when dashing

@export var FALL_ACCELERATION_NORMAL = 50.0 #the Acceleration speed for falling (normal)
@export var MAX_FALL_SPEED_NORMAL = 500.0 #the maximum speed the player can fall (normal)
@export var FALL_ACCELERATION_FAST = 100.0 #the Acceleration speed for falling (fast)
@export var MAX_FALL_SPEED_FAST = 1000.0 #the maximum speed the player can fall (fast)

@export var BUFFER_RAYCAST_BASE_LENGTH = 10.0 #the base length of the raycasts used to check for jump buffers
@export var BUFFER_RAYCAST_VELOCITY_DIVIDER = 100.0 #the ammount that the velocity get's devided by when recising the buffer raycasts

@export_category("Skills")
@export var EXTRA_JUMPS = 1 #the number of extra jumps the player can perform before landing
@export var WALL_JUMP = false #the wall jump skill (allows the player to jump off walls correctly)
@export var DASH = false #the dash skill (allows the player to dash towards the mouse cursor)
@export var LEDGE_FORGIVNESS = true
@export var RESET_JUMP_ON_WALL = false

# Private values
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #get default gravity from project settings

# Private vars
var delta

var raycasts = {'head': {},'side': {'left':{},'right':{}},'feet': {}}

var jumping = false #is the player jumping?
var jump_time = 0.0 #how long has the player been jumping?
var coyote_time = 0.0 #how long has the player been off the ground?
var double_jumps = EXTRA_JUMPS #how many double jumps does the player have left?
var doing_force = false #are we applying force?
var is_grounded = false
var is_walled = false

var current_speed = 0.0

var buffer_jump = false
var buffer_wall_jump = false
var buffer_time = 0.0

var draw_dash = false

func _ready(): #Called when the node enters the scene tree for the first time.

	#raycasts
	raycasts['head']['left'] = get_node("collision/raycasts/head/left")
	raycasts['head']['center'] = get_node("collision/raycasts/head/center")
	raycasts['head']['right'] = get_node("collision/raycasts/head/right")

	raycasts['side']['left']['top'] = get_node("collision/raycasts/side/left/top")
	raycasts['side']['left']['middle'] = get_node("collision/raycasts/side/left/middle")
	raycasts['side']['left']['bottom'] = get_node("collision/raycasts/side/left/bottom")
	raycasts['side']['left']['buffer'] = get_node("collision/raycasts/side/left/buffer")
	
	raycasts['side']['right']['top'] = get_node("collision/raycasts/side/right/top")
	raycasts['side']['right']['middle'] = get_node("collision/raycasts/side/right/middle")
	raycasts['side']['right']['bottom'] = get_node("collision/raycasts/side/right/bottom")
	raycasts['side']['right']['buffer'] = get_node("collision/raycasts/side/right/buffer")

	raycasts['feet']['buffer'] = get_node("collision/raycasts/feet/buffer")


func _draw(): #used to draw shapes and lines idk

	if draw_dash:
		var mouse_pos = get_global_mouse_position()
		#thats the global mouse position we want the local mouse position aka the mouse position in relation to the player
		mouse_pos = mouse_pos - position

		draw_line(Vector2(0,0), mouse_pos, Color(1, 0, 0), 2, true)


	pass

func _physics_process(makeMeDelta): #runs a fixed times per frame I think
	delta = makeMeDelta
	queue_redraw() #for debug purpuses

	is_grounded = is_on_floor()
	is_walled = is_touching_wall()

	if buffer_jump or buffer_wall_jump:
		if buffer_time > 0:
			buffer_time -= delta
		else:
			buffer_jump = false
			buffer_wall_jump = false

	
	if is_grounded: #if the player is on the floor
		
		jump_reset() #reset jump state
		coyote_time = COYOTE_TIME #reset coyote time
		double_jumps = EXTRA_JUMPS #reset double jumps
		
		if buffer_jump: #if the player is trying to buffer a jump
			jump() #jump
			buffer_jump = false #reset buffer jump

	elif is_walled: #if the player is on a wall (needs to move constntly towards the wall to stick to it)

		if RESET_JUMP_ON_WALL:
			double_jumps = EXTRA_JUMPS #reset double jumps

		var slide_speed = WALL_SLIDE_SPEED_NORMAL #get the noral slide speed
		if Input.is_action_pressed("down"): #if player presses down while wall sliding
			slide_speed = WALL_SLIDE_SPEED_FAST #increase the slide speed to the fast value
		elif Input.is_action_pressed("up"): #if player presses up while wall sliding
			slide_speed = WALL_SLIDE_SPEED_SLOW #decrease the slide speed to the slow value
			
		velocity.y = min(velocity.y + gravity * delta, slide_speed) #slide down the wall

	
	else: #if the player is in the air
		var max_fall_speed = MAX_FALL_SPEED_NORMAL #get the normal max fall speed
		var fall_acceleration = FALL_ACCELERATION_NORMAL #get the normal acceleration speed

		if Input.is_action_pressed("down"): #if player presses down while falling
			max_fall_speed = MAX_FALL_SPEED_FAST #increase the max fall speed to the fast value
			fall_acceleration = FALL_ACCELERATION_FAST #increase acceleration speed
			if velocity.y < 0:
				fall_acceleration *= 4 #speed up to initiate falling faster than normally
		
		velocity.y = min(velocity.y + (gravity + fall_acceleration) * delta, max_fall_speed) #apply gravity

		if coyote_time > 0: #if the player is in coyote time
			coyote_time -= delta #decrease coyote time


	#INPUT
	var direction = Input.get_axis("left", "right") #get the direction the player is trying to move in
	move(direction) #move in that direction

	if Input.is_action_just_pressed("jump"): #jump
		jump()

	if Input.is_action_pressed("dash"): #dash
		#while dash is being held down draw a line
		draw_dash = true
		Engine.time_scale = 0.1

	else:
		draw_dash = false
		Engine.time_scale = 1


	#HANDLERS
	if jumping: #hold jump button for higher jump
		if jump_time < MIN_JUMP_TIME: #while minmum time has not been reached
			velocity.y = -JUMP_FORCE
			jump_time += delta
	
		elif jump_time < MAX_JUMP_TIME and Input.is_action_pressed("jump"):
			velocity.y = -JUMP_FORCE
			jump_time += delta
		else:
			jumping = false  #set jumping to false
			jump_time = 0 #reset jump time

	ledge_forgivness()

	move_and_slide() #execute movement or something idk but it's required so don't remove it


func move(direction): #move handler
	velocity.x -= current_speed #reset velocity

	var speed = SPEED
	var acceleration = ACCELERATION
	var deceleration = DECELERATION

	if not is_grounded:
		speed = AIR_SPEED
		acceleration = AIR_ACCELERATION
		deceleration = AIR_DECELERATION


	if direction: #if player tries to move and the max speed hasn't been reached yet.
		current_speed = move_toward(current_speed, speed * direction, acceleration * delta) #still need to ask something
	else:
		current_speed = move_toward(current_speed, 0, deceleration * delta) #slow down the added movement

	velocity.x = move_toward(velocity.x, 0, deceleration * delta) #generally slow down
	velocity.x += current_speed #apply the new speed

	


func jump(): #jump handler
	if is_grounded or coyote_time > 0:
		jump_init() #jumping off the ground
		
	elif is_walled: #jumping of walls
		var wall_direction = is_touching_wall(true) #get the direction of the wall
		if WALL_JUMP: #if the player has the wall jump skill
			powaa(Vector2(wall_direction[0], -1), WALL_JUMP_FORCE) #jump off the wall

		else: #if the player does not have the wall jump skill
			powaa(wall_direction, WALL_JUMP_FORCE_BAD)

	else: #if the player presses jump while in the air

		if abs(velocity.x) > 0 or velocity.y > 0: #if player is moving to the side or down

			if velocity.y > 0:
				raycasts['feet']['buffer'].target_position.y = (velocity.y / BUFFER_RAYCAST_VELOCITY_DIVIDER) * BUFFER_RAYCAST_BASE_LENGTH #change ray length
				raycasts['feet']['buffer'].force_raycast_update() #update the raycast
				if raycasts['feet']['buffer'].is_enabled() and raycasts['feet']['buffer'].is_colliding(): #if it hit
					if check_safe_to_land(raycasts['feet']['buffer']):
						buffer_jump = true
					else:
						pass
				else:
					pass


			if velocity.x > 0:
				raycasts['side']['right']['buffer'].target_position.x = (velocity.x / BUFFER_RAYCAST_VELOCITY_DIVIDER) * BUFFER_RAYCAST_BASE_LENGTH #change ray length
				raycasts['side']['right']['buffer'].force_raycast_update() #update the raycast
				if raycasts['side']['right']['buffer'].is_enabled() and raycasts['side']['right']['buffer'].is_colliding(): #if it hit
					if check_safe_to_land(raycasts['side']['left']['buffer']):
						buffer_wall_jump = true
					else:
						pass
				else:
					pass

			elif velocity.x < 0:
				raycasts['side']['left']['buffer'].target_position.x = (velocity.x / BUFFER_RAYCAST_VELOCITY_DIVIDER) * BUFFER_RAYCAST_BASE_LENGTH #change ray length
				raycasts['side']['left']['buffer'].force_raycast_update() #update the raycast
				if raycasts['side']['left']['buffer'].is_enabled() and raycasts['side']['left']['buffer'].is_colliding(): #if it hit
					if check_safe_to_land(raycasts['side']['left']['buffer']):
						buffer_wall_jump = true
					else:
						pass
				else:
					pass
			
		else:
			if double_jumps > 0: #if the player has double jumps left
				jump_init() #jumping in the air
				double_jumps -= 1 #use a double jump


func check_safe_to_land(raycast):
	#check what we would land on
	#check if it's good for the player to land on it
	return true #return true since it doesn't matter right now


func double_jump():
	if double_jumps > 0: #if the player has double jumps left
		jump_init() #jumping in the air
		double_jumps -= 1 #use a double jump
	
func jump_reset(): #reset jump state
	jumping = false #stop jumping
	jump_time = 0 #reset jump 
	velocity.y = 0

func jump_init(jump_force = JUMP_FORCE): #initiate jump
	jumping = true #start jumping
	jump_time = 0 #reset jump time
	velocity.y = -jump_force #add force (negative because y is inverted)
	coyote_time = 0 #cancel coyote time


func dash():

	#TODO: ALLOT TO DO HERE TO MAKE THE DASH FEEL GOOD
	#TODO: also add an option to either take the direction in regards to the player or the center of the screen (QoL feature)

	var mouse_pos = get_global_mouse_position() - position
	var direction = mouse_pos.normalized()

	#while this is good we need to make it 'less' precise
	#like currently if I want to dash exactly to the right I would need to move the mouse exactly there and if I were to slightly go up or down it would also go up or down.
	#so We want to add some kind of 'deadzone' to the mouse position so that the player can dash in a direction without needing to be super precise
	#also we want to change them dynamically for example if on ground if the mouse was under the player we would just go straight left or right. (just an example we don't need to do that)
	#the point I'm trying to make is that we want to make the dash feel good and not too precise but also not too out of controll

	#let's try the lazy approach first let's just take the direction as an angle(-180 - 180) and just round it.
	#then we can play arround with the rounding to see what would be best

	var degrees = rad_to_deg(atan2(direction.y, direction.x)) #get the angle in degrees (-180 - 180)
	var round_to = 45
	degrees = round(degrees / round_to) * round_to

	var radians = deg_to_rad(degrees)
	direction = Vector2(cos(radians), sin(radians))

	#okay while the idea was good it's terrible in practice it feels so clunky now.

	# Apply the dash force
	powaa(direction, DASH_FORCE)


func powaa(direction, force):
	velocity = direction.normalized() * force #multiply the direction vector by the force to get the force vector and set is as velocity


func ledge_forgivness():
	if velocity.y >= 0 or (raycasts['head']['center'].is_enabled() and raycasts['head']['center'].is_colliding()): #if the player is not moving up or middleraycast hit
		return #do nothing

	if raycasts['head']['left'].is_enabled() and raycasts['head']['left'].is_colliding():
		if velocity.x < 0: #if moving away from ledge persumembly you don't want to go around
			return #do nothing

		while raycasts['head']['left'].is_colliding(): #while the left raycast is still colliding
			position.x += 1 #move the player to the right
			raycasts['head']['left'].force_raycast_update() #update the raycast

	elif raycasts['head']['right'].is_enabled() and raycasts['head']['right'].is_colliding():
		if velocity.x > 0:  #if moving away from ledge persumembly you don't want to go around
			return #do nothing

		while raycasts['head']['right'].is_colliding(): #while the right raycast is still colliding
			position.x -= 1 #move the player to the left
			raycasts['head']['right'].force_raycast_update() #update the raycast


func is_touching_wall(return_wall = false):
	var touching_wall = false
	var wall

	if (raycasts['side']['left']['top'].is_colliding() or raycasts['side']['left']['bottom'].is_colliding()) and raycasts['side']['left']['middle'].is_colliding():
		touching_wall = true
		wall = Vector2(1, 0)
	
	elif (raycasts['side']['right']['top'].is_colliding() or raycasts['side']['right']['bottom'].is_colliding()) and raycasts['side']['right']['middle'].is_colliding():
		touching_wall = true
		wall = Vector2(-1, 0)

	if return_wall:
		return wall
	else:
		return touching_wall