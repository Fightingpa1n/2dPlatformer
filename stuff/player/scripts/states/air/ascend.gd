extends ParentState_Air
class_name AscendState

static func id() -> String: return "ascend" #id
#this is the ascend state, which is when the player is moving upwards in the air it is different from jump
#since jump is only moving up and ascencd is slowliwly going down (that's oversimplified but that's basically it.)

func enter():
	super() #call the air state enter function
	collision.toggle_head_rays(true) #enable head rays

func exit():
	collision.toggle_head_rays(false) #disable head rays


func physics_process(delta):
	super(delta) #call the air state physics process (mostly for gravity reset)
	
	if ceiling_hit(): return #check if the player is hitting the ceiling (if state change occured return)

	if player.velocity.y > 0:
		change_state(FallState.id())
		return
	
	ledge_forgivness() #call ledge forgivness
	move(delta)


	# if InputManager.down.pressed: #while holding down the player will fast fall
	# 	if player.total_velocity().y > 0:
	# 		# change_state("fast_fall")
	# 		return

func ceiling_hit() -> bool: ##check if the player is hitting the ceiling, returns true on state change
	if collision.is_touching_ceiling():
		change_state(FallState.id())
		return true
	return false

func ledge_forgivness(): ##do ledge forgivness when accending
	var ray = collision.return_ceiling_ledge_forgiveness_thingy_idk()
	if ray:
		var direction = ray.direction
		ray = ray.ray

		while ray.is_colliding():
			player.position.x += direction * 0.1
			ray.force_raycast_update()

func on_jump_press():
	if coyote_jump(): return #coyote jump (probably not needed in the ascend state)
	if air_jump(): return #air jump

func on_horizontal_direction(_direction: float) -> void: pass #override the on_horizontal_direction as we don't want to wall in this state #TODO: add wall run
