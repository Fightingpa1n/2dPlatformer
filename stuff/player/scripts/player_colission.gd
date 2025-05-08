extends CollisionShape2D
class_name PlayerCollision

#this is the collsision script, while not doing anything by itself
#it handles all the physic stuff and collision checks to not clutter the player script
#also maybe of note this can be accessed by using "player.collision" idk I just find this very neatly organized :)

@onready var player:PlayerController = get_parent()

#=== raycasts ===#
var ray_head_left: RayCast2D
var ray_head_center: RayCast2D
var ray_head_right: RayCast2D

var ray_side_right_top: RayCast2D
var ray_side_right_center: RayCast2D
var ray_side_right_bottom: RayCast2D

var ray_side_left_top: RayCast2D
var ray_side_left_center: RayCast2D
var ray_side_left_bottom: RayCast2D

var ray_side_left_proximity: RayCast2D
var ray_side_right_proximity: RayCast2D

var ray_feet_left: RayCast2D
var ray_feet_center: RayCast2D
var ray_feet_right: RayCast2D

var ray_jump_buffer: RayCast2D


func _ready():
	var shape_size = shape.size

	#head
	ray_head_left = _create_ray("head_left", Vector2(-shape_size.x/2, -shape_size.y/2), Vector2(0, -player.CEILING_RAYCAST_LENGTH))
	ray_head_center = _create_ray("head_center", Vector2(0, -shape_size.y/2), Vector2(0, -player.CEILING_RAYCAST_LENGTH))
	ray_head_right = _create_ray("head_right", Vector2(shape_size.x/2, -shape_size.y/2), Vector2(0, -player.CEILING_RAYCAST_LENGTH))

	#sides
	ray_side_right_top = _create_ray("side_right_top", Vector2(shape_size.x/2, -shape_size.y/2), Vector2(player.WALL_RAYCAST_LENGTH, 0))
	ray_side_right_center = _create_ray("side_right_center", Vector2(shape_size.x/2, 0), Vector2(player.WALL_RAYCAST_LENGTH, 0))
	ray_side_right_bottom = _create_ray("side_right_bottom", Vector2(shape_size.x/2, shape_size.y/2), Vector2(player.WALL_RAYCAST_LENGTH, 0))

	ray_side_left_top = _create_ray("side_left_top", Vector2(-shape_size.x/2, -shape_size.y/2), Vector2(-player.WALL_RAYCAST_LENGTH, 0))
	ray_side_left_center = _create_ray("side_left_center", Vector2(-shape_size.x/2, 0), Vector2(-player.WALL_RAYCAST_LENGTH, 0))
	ray_side_left_bottom = _create_ray("side_left_bottom", Vector2(-shape_size.x/2, shape_size.y/2), Vector2(-player.WALL_RAYCAST_LENGTH, 0))

	#proximitys
	ray_side_left_proximity = _create_ray("side_left_proximity", Vector2(-shape_size.x/2, 0), Vector2(-player.WALL_PROXIMITY_RAYCAST_LENGTH, 0))
	ray_side_right_proximity = _create_ray("side_right_proximity", Vector2(shape_size.x/2, 0), Vector2(player.WALL_PROXIMITY_RAYCAST_LENGTH, 0))

	#feet
	ray_feet_left = _create_ray("feet_left", Vector2(-shape_size.x/2, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))
	ray_feet_center = _create_ray("feet_center", Vector2(0, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))
	ray_feet_right = _create_ray("feet_right", Vector2(shape_size.x/2, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))

	#other
	ray_jump_buffer = _create_ray("jump_buffer", Vector2(0, shape_size.y/2), Vector2(0, player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH))

func _create_ray(ray_name:String, start_pos:Vector2, end_pos:Vector2) -> RayCast2D: #private function to create a ray
	# print("creating ray: ", ray_name)
	var ray = RayCast2D.new()
	ray.name = ray_name
	ray.position = start_pos
	ray.target_position = end_pos
	ray.enabled = true
	ray.exclude_parent = true
	ray.collide_with_bodies = true
	ray.collide_with_areas = false
	ray.collision_mask = player.RAYCAST_COLLISION_MASK #for now it just uses the player's collision mask but it should later use one defined in the player Settings
	add_child(ray)
	ray.force_raycast_update()
	return ray


#===== toggle functions =====#

#disable/enable rays
func toggle_head_rays(enabled:bool) -> void: #toggle the head rays
	ray_head_left.enabled = enabled
	ray_head_center.enabled = enabled
	ray_head_right.enabled = enabled

func toggle_right_side_rays(enabled:bool) -> void: #toggle the right side rays
	ray_side_right_top.enabled = enabled
	ray_side_right_center.enabled = enabled
	ray_side_right_bottom.enabled = enabled

func toggle_left_side_rays(enabled:bool) -> void: #toggle the left side rays
	ray_side_left_top.enabled = enabled
	ray_side_left_center.enabled = enabled
	ray_side_left_bottom.enabled = enabled

func toggle_side_rays(enabled:bool) -> void: #toggle all side rays
	toggle_right_side_rays(enabled)
	toggle_left_side_rays(enabled)

func toggle_feet_rays(enabled:bool) -> void: #toggle the feet rays
	ray_feet_left.enabled = enabled
	ray_feet_center.enabled = enabled
	ray_feet_right.enabled = enabled

#disable/enable jump buffer
func toggle_jump_buffer_ray(enabled:bool) -> void: #toggle the jump buffer ray
	ray_jump_buffer.enabled = enabled

#disable/enable collision
func toggle_collision(enabled:bool) -> void: #toggle self collision (like if we have collision with ground and stuff)
	disabled = !enabled


#===== collision checks =====#
func is_touching_ground() -> bool: #this function checks if the player is touching the ground #NOTE: currently we check for velocity too, which is fine, but I just wanna not it incase it causes problems in the future
	var touching_ground = (ray_feet_left.is_colliding() or ray_feet_center.is_colliding() or ray_feet_right.is_colliding())
	return touching_ground and player.total_velocity().y >= 0

func is_touching_ceiling() -> bool: #checks if the player is touching the ceiling
	return (ray_head_left.is_colliding() or ray_head_right.is_colliding()) and ray_head_center.is_colliding()

func return_ceiling_ledge_forgiveness_thingy_idk(): #this function is used for ledge forgivness it will check if ledgeforgivness is applicable and if yes it will return the relevant ray so the actual code can handle the ledgeforgivness
	if ray_head_left.is_colliding() and not ray_head_center.is_colliding():
		print("ledge_forgivness")
		return {"ray": ray_head_left, "direction": 1.0}
	elif ray_head_right.is_colliding() and not ray_head_center.is_colliding():
		print("ledge_forgivness")
		return {"ray": ray_head_right, "direction": -1.0}
	else:
		return null


#===== wall stuff =====# #TODO: figure out which of the two check methods feels better
func is_touching_right_wall() -> bool: #checks if the player is touching a wall with the right side (I can't decide which check is better, for now I'll use the check for any of the rays)
	# return (ray_side_right_center.is_colliding() and ray_side_right_top.is_colliding()) or (ray_side_right_center.is_colliding() and ray_side_right_bottom.is_colliding()) #if the center ray along with either the top or bottom ray are colliding 
	return ray_side_right_top.is_colliding() or ray_side_right_center.is_colliding() or ray_side_right_bottom.is_colliding() #if any of the right side rays are colliding

func is_touching_left_wall() -> bool: #checks if the player is touching a wall with the left side (I can't decide which check is better, for now I'll use the check for any of the rays)
	# return (ray_side_left_center.is_colliding() and ray_side_left_top.is_colliding()) or (ray_side_left_center.is_colliding() and ray_side_left_bottom.is_colliding()) #if the center ray along with either the top or bottom ray are colliding
	return ray_side_left_top.is_colliding() or ray_side_left_center.is_colliding() or ray_side_left_bottom.is_colliding() #if any of the left side rays are colliding

func get_wall_direction() -> int: #gets the wall direction (aka which side the wall is on we are touching) 1=right, -1=left, 0=none/both
	var direction = 0
	if is_touching_right_wall(): direction += 1 #right wall
	if is_touching_left_wall(): direction -= 1 #left wall
	return direction

func get_wall_proximity_direction() -> int: #gets the wall direction if in proximity
	var direction = 0
	if ray_side_left_proximity.is_colliding(): direction -= 1 #left wall
	if ray_side_right_proximity.is_colliding(): direction += 1 #right wall
	return direction


#============================== Jump Buffer ==============================#
func jump_buffer_update_length(new_length:float) -> void: #updates the length of the jump buffer ray
	#ray_jump_buffer.target_position.y = (player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH/player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER) * player.total_velocity().y #this is the old code where I directly made the calculation in here instead of passing it
	print("new_length: ", new_length)
	ray_jump_buffer.target_position.y = max(new_length, 0) #update length
	ray_jump_buffer.force_raycast_update()

func did_jump_buffer_hit() -> bool:
	ray_jump_buffer.force_raycast_update()
	return ray_jump_buffer.is_colliding()

func save_to_land() -> bool: ## check if the player is save to land on the ground (Note: since everything is currently save to land, this is just a placeholder)
	return true