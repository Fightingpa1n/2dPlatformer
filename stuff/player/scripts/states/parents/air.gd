#states/parents/air.gd
extends PlayerState
class_name ParentState_Air

#the air state is the state where the player is in the air and going up aka a positive y velocity, I think.

func normal_process(delta):
	if player.coyote_time_time > 0:
		player.coyote_time_time -= delta


func wall_check():
	if player.collision.is_touching_wall():
		var wall_direction = player.collision.get_wall_direction()
		#if moving away from wall, return. or in other words if the player velocity is not towards the wall, return
		if sign(player.whole_velocity().x) != wall_direction:
			return

		if Input.get_axis("left", "right") == wall_direction:
			player.change_state("walled")
	

func ground_check(): #a recyclable function for checking the ground
	if player.collision.is_touching_ground():
		player.change_state("idle")
		return true
	else:
		return false


func move(delta): #a recyclable function for moving the player in the air
	var movement_direction = Input.get_axis("left", "right")

	if movement_direction != 0:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, movement_direction * player.AIR_MOVE_SPEED, player.AIR_MOVE_ACCELERATION * delta)
	else:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, player.AIR_MOVE_DECELERATION * delta)


func double_jump():
	if player.jump_counter < player.EXTRA_JUMPS:
		player.jump_counter += 1
		player.change_state("jump")


func on_input_jump():
	if player.coyote_time_time > 0:
		player.coyote_time_time = 0
		player.change_state("jump")
		return true
	else:
		return false