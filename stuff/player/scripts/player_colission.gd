#collision.gd
extends CollisionShape2D

#this is the collsision script, while not doing anything by itself
#it handles all the physic stuff and collision checks to not clutter the player script
#also maybe of note this can be accessed by using "player.collision" idk I just find this very neatly organized :)

var player: CharacterBody2D

var ray_head_left: RayCast2D
var ray_head_center: RayCast2D
var ray_head_right: RayCast2D

var ray_side_right_top: RayCast2D
var ray_side_right_center: RayCast2D
var ray_side_right_bottom: RayCast2D

var ray_side_left_top: RayCast2D
var ray_side_left_center: RayCast2D
var ray_side_left_bottom: RayCast2D

var ray_feet_left: RayCast2D
var ray_feet_center: RayCast2D
var ray_feet_right: RayCast2D

var ray_jump_buffer: RayCast2D #this buffer is used for jump buffering since in my oppinion it's supperior to the timer normally used for this.

func _ready():
	player = get_parent()
	await player.ready
	init_rays()

func init_rays():
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

	#feet
	ray_feet_left = _create_ray("feet_left", Vector2(-shape_size.x/2, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))
	ray_feet_center = _create_ray("feet_center", Vector2(0, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))
	ray_feet_right = _create_ray("feet_right", Vector2(shape_size.x/2, shape_size.y/2), Vector2(0, player.FLOOR_RAYCAST_LENGTH))

	#other
	ray_jump_buffer = _create_ray("jump_buffer", Vector2(0, shape_size.y/2), Vector2(0, player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH))

func _create_ray(ray_name: String, start_pos: Vector2, end_pos: Vector2) -> RayCast2D:
	#print("creating ray: ", ray_name)
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


#floor stuff
func is_touching_ground() -> bool:
	#we might want to change this at a later point to exclude the velocity check but for now it's good like this
	var touching_ground = (ray_feet_left.is_colliding() or ray_feet_center.is_colliding() or ray_feet_right.is_colliding())
	return touching_ground and player.total_velocity().y >= 0


#Ceiling stuff
func change_enabled_rays_head(enabled: bool) -> void: #we only need the head rays while the player is going up so we can disable it while either not chnaging height or going down
	ray_head_left.enabled = enabled
	ray_head_center.enabled = enabled
	ray_head_right.enabled = enabled

func is_touching_ceiling() -> bool:
	if (ray_head_left.is_colliding() or ray_head_right.is_colliding()) and ray_head_center.is_colliding():
		print("touching ceiling")
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


#Wall stuff
func is_touching_wall() -> bool:
	var right_side = ray_side_right_top.is_colliding() or ray_side_right_center.is_colliding() or ray_side_right_bottom.is_colliding()
	var left_side = ray_side_left_top.is_colliding() or ray_side_left_center.is_colliding() or ray_side_left_bottom.is_colliding()
	return right_side or left_side

func get_wall_direction() -> int:
	var right_side = ray_side_right_top.is_colliding() or ray_side_right_center.is_colliding() or ray_side_right_bottom.is_colliding()
	var left_side = ray_side_left_top.is_colliding() or ray_side_left_center.is_colliding() or ray_side_left_bottom.is_colliding()
	if right_side and left_side:
		return 0
	elif right_side:
		return 1
	elif left_side:
		return -1
	else:
		return 0


#jump buffer stuff
func change_enabled_jump_buffer(enabled: bool) -> void: #the jump buffer is only needed when the player is falling
	ray_jump_buffer.enabled = enabled

func jump_buffer_update_length() -> void:
	#TODO: maybe this calculation should get a seccond look at some point but for now it works, the question is if it makes sense
	ray_jump_buffer.target_position.y = (player.JUMP_BUFFER_RAYCAST_INITAL_LENGTH/player.JUMP_BUFFER_RAYCAST_VELOCITY_MULTIPLIER) * player.total_velocity().y
	ray_jump_buffer.force_raycast_update()

func did_jump_buffer_hit() -> bool:
	ray_jump_buffer.force_raycast_update()
	return ray_jump_buffer.is_colliding()

