#states/parents/wall.gd
extends GrandParentState
class_name ParentState_Wall

#normally parent states are here to provide a common interface for their children but wallled is a bit of a special case #Future me: idk what that means?

var wall_direction: int

func enter():
    #on entering the wall state, we would like to get the wall direction
    wall_direction = player.collision.get_wall_direction()

    #reset stuff
    if player.RESET_JUMP_COUNTER_ON_WALL:
        player.jump_counter = 0
    
    #TODO: add Wall jump buffering

func physics_process(_delta):
    ground_check()
    wall_check()

func ground_check() -> void:
    if player.collision.is_touching_ground():
        player.change_state("idle")

func wall_check() -> void:
    if not player.collision.is_touching_wall():
        player.change_state("fall")

    
func get_wall_direction() -> int:
    return wall_direction
