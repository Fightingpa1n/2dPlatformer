#states/walled.gd
extends PlayerState
class_name State_Walled

#the wall state is the state when the player is on a wall.

var wall_direction: int = 0 #0 = none/both, 1 = right -1 = left

func enter(): #on entering t
	player.velocity.y = 0.0	
	wall_direction = player.collision.get_wall_direction()

	#reset some variables
	player.jump_time = 0.0
	player.coyote_time_time = player.COYOTE_TIME
	player.jump_counter = 0

func exit():
	player.movement_velocity.y = 0.0

func physics_process(delta):
	if not player.collision.is_touching_wall():
		player.change_state("fall")
		return
	
	if player.collision.is_touching_ground():
		player.change_state("idle")
		return

	#wall slide
	var wall_slide_speed = player.WALL_SLIDE_SPEED

	if Input.is_action_pressed("up"):
		wall_slide_speed = player.WALL_SLIDE_SPEED_SLOW
	elif Input.is_action_pressed("down"):
		wall_slide_speed = player.WALL_SLIDE_SPEED_FAST

	var speed_alter_var = player.WALL_SLIDE_ACCELERATION if player.whole_velocity().y < wall_slide_speed else player.WALL_SLIDE_DECELERATION
	player.movement_velocity.y = move_toward(player.movement_velocity.y, wall_slide_speed, speed_alter_var * delta) #if we wanna speed up
	#but we wanna use deceleration if we are slowing down or just generally reducing the sliding speed

func on_input_jump():
	print("WALL_JUMP")
	var jump_direction = Vector2(wall_direction * player.WALL_JUMP_DIRECTION.x, player.WALL_JUMP_DIRECTION.y)
	player.powaaa(jump_direction, player.WALL_JUMP_FORCE)
	player.change_state("ascend")


func on_input_left_right(direction):
	#if we go opposite direction of the wall we are on, we should fall down
	if direction != 0 and direction != wall_direction:
		player.change_state("fall")
		return