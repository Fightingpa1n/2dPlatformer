#states/parents/parent.gd
extends PlayerState
class_name GrandParentState

#ah yes the grandparent state. the parent of the parent states, here I will put stuff shared between all parent states or just used

#physic functions
func physics_gravity(delta: float) -> void:
    player.movement_velocity.y = move_toward(player.movement_velocity.y, player.FALL_SPEED, player.FALL_ACCELERATION * delta)

func physics_deceleration(deceleration: float, delta: float) -> void: #deceleration function. used to slow down the players x velocitys 
    if abs(player.velocity.x) > 0:
        player.velocity.x = move_toward(player.velocity.x, 0, deceleration * delta)
    if abs(player.other_velocity.x) > 0:
        player.other_velocity.x = move_toward(player.other_velocity.x, 0, deceleration * delta)

func physics_movement_deceleration(deceleration: float, delta: float) -> void: #decelerating function for the movement velocity
    if abs(player.movement_velocity.x) > 0:
        player.movement_velocity.x = move_toward(player.movement_velocity.x, 0, deceleration * delta)

    
