#states/powaad.gd
extends ParentState_Air
class_name State_Powaad

# this is the state when the powaaa function has been used to catapult the player into a direction so this state is here to make it actually work

func physics_process(delta):
    move(delta) #while falling we are allowed to move
    ground_check()


