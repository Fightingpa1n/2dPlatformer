#states/walk.gd
extends ParentState_Grounded
class_name State_Walk

#this is the walking state, it's when the player is moving left or right without mutch else

func physics_process(delta):
	ground_check()

	var movement_direction = Input.get_axis("left", "right")

	if movement_direction != 0:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, movement_direction * player.WALK_SPEED, player.WALK_ACCELERATION * delta)
	else:
		player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, player.WALK_DECELERATION * delta)

	if player.velocity.x != 0:
		player.velocity.x = move_toward(player.velocity.x, player.movement_velocity.x, player.WALK_ACCELERATION * delta)
	
	if player.movement_velocity.x == 0:
		player.change_state("idle")

