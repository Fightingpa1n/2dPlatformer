#states/ascend.gd
extends ParentState_Air
class_name State_Ascend

#this is the ascend state, which is when the player is moving upwards in the air it is different from jump 
#since jump is only moving up and ascencd is slowliwly going down (that's oversimplified but that's basically it.)
func enter():
	collision.toggle_head_rays(true)

func exit():
	collision.toggle_head_rays(false)


func physics_process(delta):
	move(delta)
	wall_check()
	ceiling_hit()
	ledge_forgivness()

	if Input.is_action_pressed("down"):
		player.velocity.y = move_toward(player.velocity.y, player.FASTFALL_SPEED, player.FASTFALL_ACCELERATION * delta)

		if player.total_velocity().y > 0:
			player.change_state("fast_fall")

	else:
		player.velocity.y = move_toward(player.velocity.y, player.FALL_SPEED, player.FALL_ACCELERATION * delta)

		if player.total_velocity().y > 0:
			player.change_state("fall")


func ceiling_hit():
	if collision.is_touching_ceiling():
		player.change_state("fall")


func ledge_forgivness():
	var ray = collision.return_ceiling_ledge_forgiveness_thingy_idk()
	if ray:
		var direction = ray.direction
		ray = ray.ray

		while ray.is_colliding():
			player.position.x += direction * 0.1
			ray.force_raycast_update()

func on_input_jump():
	if not super():
		double_jump()
